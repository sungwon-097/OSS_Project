# 🔖 Open Source design baSic _ Project
## ⛑️ Detects wearing a helmet

|Team 11|Weeks|Distributing roles|
|-|-|-|
|-|Week1|개발환경을 세팅, `Dataset` 준비 및 라벨링 작업|
|-|WeeK2|라벨링된 이미지를 `keras`라이브러리를 이용해 학습시킴|
|-|Week3|학습시킨 데이터를 `RaspberryPi`에 적용해 테스트함|
|-|WeeK4|설정값을 변경하며 원하는 결과가 나올 때까지 테스트를 진행|

## Needs

- >Darknet YOLO3 Tiny Framework
- >keras Library
- >RaspberryPi
    - Camera
    - Speaker

* * *
## Summary :
```
운전자의 안전모 착용 유무를 확인하여 미착용시 경고음을 출력한다.

Darknet의 yolo3 tiny 프레임워크 오픈소스를 사용하여 안전모 착용모습을 학습시킴.
인식에 실패할 경우 경고음을 내보낸다

머리를 보호 할 수 있는 안전 장비라면(모자나 방한용품은 제외) 모두 인식이 될 수 
있도록 신뢰도가 높은 dataset을 준비해야하고 미인식시에 정상적으로 스피커에서 
출력이 발생 할 수 있도록 해야 한다.

중상이나 사망사고를 줄일 수 있는 방안이 될 것이다. 또한, 이용자들의 안전 장비 
착용에 대한 인식 개선에도 기여할 것으로 기대가 된다
```

## Thanks for


- Darknet Framework : [Darknet](https://github.com/pjreddie/darknet.gi, "darknet link")

- Keras Library : [Keras](https://github.com/keras-team/keras.git, "keras link")

# How to Use?

### Labeling

- https://github.com/tzutalin/labelImg.git

```python
<annotation>
	<folder>lamp_on</folder>
	<filename>0.jpg</filename>
	<path>/lamp_on/0.jpg</path>
	<source>
		<database>Unknown</database>
	</source>
	<size>
		<width>1920</width>
		<height>1080</height>
		<depth>3</depth>
	</size>
	<segmented>0</segmented>
	<object>
		<name>lamp_on</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>704</xmin>
			<ymin>384</ymin>
			<xmax>970</xmax>
			<ymax>546</ymax>
		</bndbox>
	</object>
</annotation>
# labelImg는 이미지 상의 오브젝트의 위치와 종류를 xml 형태로 반환합니다.
```

### Resizing

- Image Resizing
```python
from PIL import Image
for image_file in images:
  image = Image.open(image_file)
  resize_image = image.resize((192, 108))
  resize_image.save(new_path)
```

-  Label Resizing
```python
def changeLabel(xmlPath, newXmlPath, imgPath, boxes):
    tree = elemTree.parse(xmlPath)

    # path 변경
    path = tree.find('./path')
    path.text = imgPath[0]

    # bounding box 변경
    objects = tree.findall('./object')
    for i, object_ in enumerate(objects):
        bndbox = object_.find('./bndbox')
        bndbox.find('./xmin').text = str(boxes[i][0])
        bndbox.find('./ymin').text = str(boxes[i][1])
        bndbox.find('./xmax').text = str(boxes[i][2])
        bndbox.find('./ymax').text = str(boxes[i][3])
    tree.write(newXmlPath, encoding='utf8')
```

### Image Generating
- horizontal flip
```python
import random
import numpy as np
class RandomHorizontalFlip(object):
    def __init__(self, p=0.5):
        self.p = p

    def __call__(self, img, bboxes):
        img_center = np.array(img.shape[:2])[::-1]/2
        img_center = img_center.astype(int)
        img_center = np.hstack((img_center, img_center))
        if random.random() < self.p:
            img = img[:, ::-1, :]
            bboxes[:, [0, 2]] += 2*(img_center[[0, 2]] - bboxes[:, [0, 2]])
            box_w = abs(bboxes[:, 0] - bboxes[:, 2])
            bboxes[:, 0] -= box_w
            bboxes[:, 2] += box_w
        return img, bboxes
```
- label generating 
```python
for imgFile in imgFiles:
    fileName = imgFile.split('.')[0]
    label = f'{labelPath}{fileName}.xml'
    w, h = getSizeFromXML(label)

    # opencv loads images in bgr. the [:,:,::-1] does bgr -> rgb
    image = cv2.imread(imgPath + imgFile)[:,:,::-1]
    bboxes = getRectFromXML(classes, label)

    # HorizontalFlip image
    image, bboxes = RandomHorizontalFlip(1)(image.copy(), bboxes.copy())

    # Save image
    image = Image.fromarray(image, 'RGB')
    newImgPath = f'./data/light/image/train/{className}/'
    if not os.path.exists(newImgPath):
        os.makedirs(newImgPath)
    image.save(newImgPath + imgFile)

    # Save label
    newXmlPath = f'./data/light/label/train/{className}/'
    if not os.path.exists(newXmlPath):
        os.makedirs(newXmlPath)
    newXmlPath = newXmlPath + fileName + '.xml'
    changeLabel(label, newXmlPath, newImgPath, bboxes)
```

### YOLO Training - keras
- tiny yolov3 pretrained weights 
```
wget https://pjreddie.com/media/files/yolov3-tiny.weights
```
- Convert darknet model to keras model
```
python convert.py yolov3-tiny.cfg yolov3-tiny.weights model_data/yolo_tiny.h5
```
- tiny YOLO v3 converted model test
```python
from IPython.display import display
from PIL import Image
from yolo import YOLO

def objectDetection(file, model_path, class_path):
    yolo = YOLO(model_path=model_path, classes_path=class_path, anchors_path="model_data/tiny_yolo_anchors.txt")
    image = Image.open(file)
    result_image = yolo.detect_image(image)
    display(result_image)

objectDetection('dog.jpg', 'model_data/yolo_tiny.h5', 'model_data/coco_classes.txt'
```

### Convert Annotation
- Annotation example
```
path/to/img1.jpg 50,100,150,200,0 30,50,200,120,3
path/to/img2.jpg 120,300,250,600,2
```
- Convert annotation
```python
import xml.etree.ElementTree as ET
from os import getcwd
import glob

def convert_annotation(annotation_voc, train_all_file):
    tree = ET.parse(annotation_voc)
    root = tree.getroot()

    for obj in root.iter('object'):
        difficult = obj.find('difficult').text
        cls = obj.find('name').text
        if cls not in classes or int(difficult)==1: continue
        cls_id = classes.index(cls)
        xmlbox = obj.find('bndbox')
        b = (int(xmlbox.find('xmin').text), int(xmlbox.find('ymin').text), int(xmlbox.find('xmax').text), int(xmlbox.find('ymax').text))
        train_all_file.write(" " + ",".join([str(a) for a in b]) + ',' + str(cls_id))

train_all_file = open('./data/light/train_all.txt', 'w')

# Get annotations_voc list
for className in classes:
    annotations_voc = glob.glob(f'./data/light/label/train/{className}/*.xml')
    for annotation_voc in annotations_voc:
        image_id = annotation_voc.split('/')[-1].split('.')[0]+'.JPG'
        train_all_file.write(f'./data/light/image/train/{className}/{image_id}')
        convert_annotation(annotation_voc, train_all_file)
        train_all_file.write('\n')
train_all_file.close()
```