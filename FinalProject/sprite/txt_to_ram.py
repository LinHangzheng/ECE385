
def txt_to_ram(filename):
    with open("%s.txt"%filename,"r") as f:
        count1 = 0
        count2 = 0
        output =''
        while 1:
            data = f.readline()
            if not data:
                break
            out = data[:-1].zfill(2)

            print(out)
            output +=out
            count1 = -count1 + 1
            count2 +=1
            if count2 == 16:
                count2 = 0
                output+='\n'
            elif not count1:
                output+=' '

        with open("%s.ram"%filename,"w") as f2:
            f2.write(output)

if __name__ == "__main__":
    filename = 'background'
    txt_to_ram(filename)
