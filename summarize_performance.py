#%% 

import os
from os import path
import pickle
import pandas as pd
import matplotlib.pyplot as plt
import json
import matplotlib

df=pd.DataFrame(columns=['epoch','conv','prec1','prec5','loss_log'])
df_aoa=pd.DataFrame(columns=['epoch','conv','aoa','loss','node'])

for epoch in range(0,80):
    for conv in range(1,6):
        lcpth='/home/ubuntu/linearclass/linearclass_time_%d_conv_%d'%(epoch,conv)
        print(lcpth)
        d={'epoch':[epoch],'conv':[conv]}
        for item in ['prec1','prec5','loss_log']:
            itpth=path.join(lcpth,'log',item)
            if path.exists(itpth):
                with open(itpth,'rb') as f:
                    it=pickle.load(f)
                    d[item]=float(it[0])
        if 'prec1' in d.keys():
            df=df.append(pd.DataFrame.from_dict(d),ignore_index=True)

df.to_csv('/home/ubuntu/linearclass/summarize_performance_summary.csv')
print(df)

