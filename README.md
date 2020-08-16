# data_build
Build data table for NGINX logs for termgraph

# Usage
Run on a server that utilizes NGINX or contains NGINX logs. Currently the file paths are hard coded. The script will require three days' worth of logs

# Sample:
```
$ ./data_build.sh testsite
Copy the below output in order to build the data file:

@ 16/Aug/2020,15/Aug/2020,14/Aug/2020
00:00   913     2797    2797
01:00   1403    2744    2744
02:00   1635    3076    3076
03:00   1686    2196    2196
04:00   953     1377    1377
05:00   993     1237    1237
06:00   1253    1124    1124
07:00   1402    1578    1578
08:00   1140    1077    1077
09:00   1586    1319    1319
10:00   1252    1984    1984
11:00   1576    2236    2236
12:00   2194    3173    3173
13:00   99728   3195    3195
14:00   4527    3615    3615
15:00   2363    3511    3511
16:00   2734    4266    4266
17:00   1683    2536    2536
18:00   2223    2283    2283
19:00   2194    2280    2280
20:00   2549    1906    1906
21:00   1476    2893    2893
22:00   0       2446    2446
23:00   0       1968    1968
```

Copy the relevant part of the above output and save it on a device that has `termgraph` installed. You can then run the following:

![1__tmux](https://user-images.githubusercontent.com/54643953/90345427-05bd8500-dfe6-11ea-96a4-8b1f6831b2b8.png)
