'''
30%ぐらい早くなるらしいけど、イマイチ効果が分からなかった
'''
def pylist_append(num_list, range):
    for x in xrange(range):
        num_list.append(x)
    return num_list

def cylist_append(list num_list, range):
    for x in xrange(range):
        num_list.append(x)
    return num_list

def pydict_append(num_dic, range):
    for x in xrange(range):
        num_dic[x] = x**2
    return num_dic

def cydict_append(dict num_dic, range):
    for x in xrange(range):
        num_dic[x] = x**2
    return num_dic
