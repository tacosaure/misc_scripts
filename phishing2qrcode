from tkinter import Tk     # from tkinter import Tk for Python 3.x
from tkinter.filedialog import askopenfilename
import csv
import os

from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

from tempfile import NamedTemporaryFile
import shutil

import qrcode

#Tk().withdraw() # we don't want a full GUI, so keep the root window from appearing
filename = askopenfilename() # show an "Open" dialog box and return the path to the selected file

print(filename)

tempfile = NamedTemporaryFile(mode='w', delete=False,newline='')

#csv_file = open(filename)
fields=['date_reported','type','value','status','traitement']


with open(filename, 'r') as csvfile, tempfile:
    csvreader = csv.DictReader(csvfile,fieldnames=fields)
    fields=csvreader.fieldnames
    print(fields)
    csvwriter = csv.DictWriter(tempfile, fieldnames=fields)


    file_path = os.path.dirname(filename)
    new_folder_name = "phishing_qrcode"
    new_path = file_path+"/"+new_folder_name
    isExist = os.path.exists(new_path)
    if not isExist:
      # Create a new directory because it does not exist 
        os.makedirs(new_path)
        print("The new directory is created! : " +new_path)
    else:
        print("The folder "+new_path+" already exists")
    #print(row['status'])

    rows = []
    csvwriter.writeheader()
    for row in csvreader:
        row['traitement'] = ""
        if row['status'] == 'feedback_required':
            print("found")
            print(row)
            row['traitement'] = "" #need user input
            print(row)


            

            


            url=row['value']
            deob=row['value'].replace("[.]",".").replace("XX","tt")
            #print(deob)
            name = deob.replace("://","_").replace("/","-")
            output_path=new_path+"/"+name+".png"
            
            
            qr = qrcode.QRCode(box_size=10)
            qr.add_data(deob)
            img=qr.make_image()
            
            
            #img = qrcode.make(deob)            
            draw = ImageDraw.Draw(img)
            font = ImageFont.truetype("arial.ttf",15)
            draw.text((0,0),url,font=font)            
            img.save(output_path)
            print("Qrcode created for "+row['value']+ " at "+output_path)
            
            
            rows.append(row)
            
            
        row = {'date_reported':row['date_reported'],'type':row['type'],'value':row['value'],'status':row['status'],'traitement':row['traitement']} 
        csvwriter.writerow(row)
            
    print(rows)

shutil.move(tempfile.name, filename)
#csv_file.close()
