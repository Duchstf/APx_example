import argparse

from struct import unpack;
from os import urandom

ap = argparse.ArgumentParser()
ap.add_argument("-l", "--linkCnt", required=False, default=4, help="Link Count")
ap.add_argument("-w", "--wordCnt", required=False, default=4, help="Word Count")
ap.add_argument("-d", "--datatype", required=False, default="zero", choices=['rnd','cnt','zero'],help="Data type ")
args = vars(ap.parse_args())


linkCnt=int(args['linkCnt'])
wordCnt=int(args['wordCnt'])
datatype=(args['datatype'])

print ("")
print ("WordCnt             ", end='')
for x in range(linkCnt):
     print ("LINK_{:02d}               ".format(x), end='')
print ("")
print ("#BeginData")

for x in range(wordCnt):
     print("0x{:04x}   ".format(x), end='')
     for y in range(linkCnt):
          if (datatype == "rnd"):
              data=unpack("!Q",  urandom(8))[0]
          elif (datatype == "cnt"):
              data=x
          else:
              data=0
          print("0x{:016x}    ".format(data), end='')
     print("")

