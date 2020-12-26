import random


def create_data():
    with open("/usr/share/dict/words") as f:
        WORDS = f.readlines()
        size = len(WORDS)

        print("#id,first_name,last_name")
        for i in range(100000000):
            first_name = WORDS[random.randint(0, size-1)].replace("\n","").replace("'","")
            last_name = WORDS[random.randint(0, size-1)].replace("\n","").replace("'","")
            print(""+str(i)+","+str(first_name)+","+str(last_name))

        """need to copy the output to master and workers, or on s3"""


if __name__ == '__main__':
    create_data()
