import MeCab, math

def test(strings, N):
    p_li=[]
    for i in xrange(N):
        f_di = count_word(strings)
        p_li.append(get_prob(f_di))
    return aggregate_dict(p_li)

def count_word(strings):
    dict={}
    t = MeCab.Tagger()
    node = t.parseToNode(strings)
    while node:
        if node.surface in dict:
            dict[node.surface] += 1
        else:
            dict[node.surface] = 1
        node = node.next
    return dict

def get_prob(freq_dic):
    probdic = {}
    word_sum = sum(freq_dic.itervalues())
    for word in freq_dic:
        probdic[word] = math.log(1.0 * freq_dic[word] / word_sum)
    return probdic

def aggregate_dict(dict_list):
    word_set=set([])
    word_dic={}
    for dic1 in dict_list:
        for word in [w_li for w_li in dic1 if not w_li in word_set]:
            word_set = word_set.union(word)
            value=0
            for dic in [di_li for di_li in dict_list if word in di_li]:
                value += dic[word]
            word_dic[word] = value
    return word_dic