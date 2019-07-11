#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
print(os.listdir("../input/googlenewsvectorsnegative300"))


# In[2]:


from gensim.models.keyedvectors import KeyedVectors
embedding_file = "../input/googlenewsvectorsnegative300/GoogleNews-vectors-negative300.bin"
print("Loading word vectors...")
word_vectors = KeyedVectors.load_word2vec_format(embedding_file, binary=True)
word_vectors.similarity('france', 'spain')


# In[3]:


import pandas as pd
df = pd.read_csv("../input/word353/combined.csv")
word1=df['Word 1']
word2=df['Word 2']
human=df['Human (mean)'].values


# In[4]:


word2vec_score=[]
for i in range(353):
    w2vs=word_vectors.similarity(word1[i],word2[i])
    #print(word1[i],word2[i],w2vs)
    word2vec_score.append(w2vs)
    if i%50 ==0 or i==352:
        print(i)


# In[ ]:


#word2vec_score


# In[6]:


get_ipython().run_line_magic('matplotlib', 'inline')
import matplotlib.pyplot as plt
#ax.plot([1, 2, 3, 4], [10, 20, 25, 30], color='lightblue', linewidth=3)
plt.scatter(human,word2vec_score, marker='o')
plt.xlabel('Human')
plt.ylabel('word2vec')
plt.title("Human similarity Vs word2vec")
plt.savefig('word2vec.png')
plt.show()


# In[ ]:




