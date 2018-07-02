import sys
import read_dump
import phantom as p
import time
#import resource

start = time.time()

p.phantom(read_dump.main(sys.argv[1], int(sys.argv[2]),int(sys.argv[3])))

end = time.time()

duration = end-start

if duration < 60:
	print("Duration: %f seconds" % (duration))
elif duration < 3600:
	print("Duration: %f minutes" % (duration/60))
else:
	print("Duration: %f hours" % ((duration/60)/60))

#This information is only available on linux.
#print("Max RAM usage: %f gb" % (resource.getrusage(resource.RUSAGE_SELF).ru_maxrss/1000000))
