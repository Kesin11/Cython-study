import MeCab

cdef extern from "math.h":
    double log(double)
    
cpdef test(char* strings, int N):
    p_li=[]
    cdef dict f_di
    cdef int i
    for i in range(N):
        f_di = count_word(strings)
        p_li.append(get_prob(f_di))
    return aggregate_dict(p_li)

cdef count_word(char* strings):
    cdef dict dic = {}
    cdef object t = MeCab.Tagger()
    cdef object node = t.parseToNode(strings)
    while node:
        if node.surface in dic:
            dic[node.surface] += 1
        else:
            dic[node.surface] = 1
        node = node.next
    return dic

cdef get_prob(dict freq_dic):
    cdef dict probdic={}
    cdef double prob
    cdef double word_sum
    word_sum = sum(freq_dic.itervalues())
    for word in freq_dic:
        #warning! double/double -> double , double/int -> int?
        prob = (freq_dic[word] / word_sum)
        probdic[word] = log(prob)
    return probdic

cdef aggregate_dict(list dict_list):
    word_set=set([])
    cdef float value
    cdef dict word_dic={}
    for dic1 in dict_list:
        for word in [w_li for w_li in dic1 if not w_li in word_set]:
            word_set = word_set.union(word)
            value=0
            for dic in [di_li for di_li in dict_list if word in di_li]:
                value += dic[word]
            word_dic[word] = value
    return word_dic