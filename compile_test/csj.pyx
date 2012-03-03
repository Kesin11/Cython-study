#coding: utf-8
import os, re, MeCab, codecs, argparse
from multiprocessing import Pool
'''
コマンドラインオプション
-m: マルチコアで動作させる
-c filename: コア講演情報のファイルを読み込む
time:全講演(3302)
real    14m53.062s
user    8m10.196s
sys    3m21.001s
time:コア講演(177)
real    0m40.769s
user    0m25.362s
sys    0m10.923s

10/4 multi_option=False, filename=None
real    13m58.589s
user    8m50.960s
sys    3m21.176s
10/4 multi_option=True, filename=None
real    7m19.910s
user    13m13.584s
sys    5m3.401s
'''

def split_utterance(list str_list):
    '''発話単位で区切る'''
    utterance_str_list = []
    strings = ""
    pattern = re.compile(r'(^\d{4}.*L:)')
    for str in str_list:
        str_re = pattern.search(str)
        #発話情報
        if str_re:
            utterance_str_list.append(strings)
            strings = str_re.group(1)+"\n"
        #内容
        else:
            strings += str
    return utterance_str_list

def check_word(strings):
    #本田先輩の判定方法
    if re.search("名詞|動詞|形容詞|未知語",strings):
        if not re.search("数|接尾|代名詞|非自立",strings):
            return True
    return False
def count_word(strings, option=""):
    '''引数：文字列リスト
        処理：名詞カウント
        戻り値：名詞の辞書
    '''
    word_dict={}
    str_list = strings.split('\n')
    #utterance:発話情報、word:単語頻度
    
    dic={'utterance': re.search(r'\d{4}', str_list.pop(0)).group(0),
          'word': word_dict}
    t = MeCab.Tagger(option)
    noise = re.compile(u"<.+?>|\(F.+?\)")
    yomi = re.compile(u"& .+")
    utterance = re.compile(u"^\d{4} \d{5}")
    for line in str_list:
        word = ""
        #ノイズ除去
        line = noise.sub(u" ", line)
        #読み除去
        line = yomi.sub(u"", line)
        #発話情報無視
        #発話情報抜き出しはいらないかも
        if not utterance.search(line):
            node = t.parseToNode(line.encode('utf-8'))
            while node:
                if check_word(node.feature):
                    word += node.surface
                else:
                    if word is not "":
                        if word in word_dict:
                            word_dict[word] += 1
                        else:
                            word_dict[word] = 1
                        word = ""
                '''名詞連結をしないならこっち
                if "名詞" in node.feature:
                    if node.surface in dic:
                        dic[node.surface] += 1
                    else:
                        dic[node.surface] = 1 
                '''
                node = node.next
    return dic

def get_filelist(ROOT, core_list=None):
    '''ルート内の.trnファイルのパスを抽出'''
    file_list=[]
    pattern = re.compile("(.*)\.trn$")
    for root, dirs, files in  os.walk(ROOT):
        #抽出リストが存在するとき
        if core_list:
            for file in files:
                if pattern.search(file).group(1) in core_list:    
                    dic = {'path': os.path.join(root, file), 'name': pattern.search(file).group(1)}
                    file_list.append(dic.copy())
        else:
            for file in files:
                dic = {'path': os.path.join(root, file), 'name': pattern.search(file).group(1)}
                file_list.append(dic.copy())
    return file_list

def dict_add(dict d1, dict d2):
    '''２つの辞書をマージ。重複するキーのアイテムは加算'''
    dic=d1.copy()
    for key in d2:
        if key in dic:
            dic[key] = dic[key] + d2[key]
        else:
            dic[key] = d2[key]
    return dic
            
def out_result(out_file, file_name, word_dict, center):
    '''結果をファイル出力．名詞は頻出順にソート'''
    word_list=[]
    for word, count in sorted(word_dict.items(), key=lambda x:x[1], reverse=True):
        word_list.append(str(count)+" "+word+"\n")
    #center_utterance = re.search(u"^\d{4} \d{5}", center)
    out_file.write("@%s-%s\n" %(file_name, center))
    #out_file.write("@%s:%s\n" %(file_name, re.sub(u' ', u'_', center)))
    #out_file.writelines("@%s-%s\n" %(file_name, str(i)))
    out_file.writelines(word_list)

GLOBAL_i = 1
if __name__ == '__main__':
    ROOT="/Users/kase/CSJ"
    W_SIZE=7
    W_MOVE=1
    output_file = open("/Users/kase/tmpdata/freqfile_csj", 'w')
    
    #オプション設定
    parser = argparse.ArgumentParser(description='create freqfile')
    parser.add_argument('-m','--multi', action="store_true", default=False, dest='multi_option', help='enable multi process')
    parser.add_argument('-c','--core',  action="store", default=None, dest='filename')
    option = parser.parse_args()
    
    #引数でコアファイルを指定すれば読み込む
    if option.filename:
        core_list = codecs.open(option.filename, 'r').read().split('\n')
    else:
        core_list = None
    #コアファイルのみ抽出
    file_list = get_filelist(ROOT, core_list)
    
    #マルチコアオプション
    if option.multi_option:
        pool = Pool()
    else:
        pool = Pool(1)
    
    print 'Core file = ', option.filename
    print 'Enable multiple process = ', option.multi_option
    
    for i, file_dict in enumerate(file_list):
        print "%d of %d: %s" % (len(file_list), i+1, file_dict['name'])
        str_list = codecs.open(file_dict['path'], 'r', 'euc-jp').readlines()
        #発話で区切る
        utterance_str_list = split_utterance(str_list)
        #発話ごとの単語カウント
        utterance_word_list = pool.map(count_word, utterance_str_list)
        for j in [x*W_MOVE for x in range(len(utterance_word_list))]:
                #窓は1刻みで動かす。中心と前後7発話の単語カウントをまとめる
                #配列を超えないように
                if (j+W_SIZE*2) < len(utterance_word_list):
                    #7発話文の辞書から単語だけ切り出してまとめる
                    utterance_dict = reduce(dict_add, [utterance['word'] for utterance in utterance_word_list[j:j+W_SIZE*2]])
                    #@ファイル名+中心発話情報
                    out_result(output_file, file_dict['name'], utterance_dict, utterance_word_list[j+W_SIZE]['utterance'])
                else:
                    for utterance in utterance_word_list[j:]:
                        utterance_dict = dict_add(utterance_dict, utterance['word'])
                    out_result(output_file, file_dict['name'], utterance_dict, utterance_word_list[j+W_SIZE]['utterance'])
                    #窓の上限が配列に端に到達したら終了
                    break
    '''
    テスト用
    test_dict = {'path': '/home/kase/CSJ/A01F0001.trn' , 'name': 'test'}
    test_dict['noun'] = count_noun(test_dict['path'])
    out_result(output_file, test_dict)
    '''
