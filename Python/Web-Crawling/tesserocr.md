# tesserocr


OCR

> Optical Character Recognition，光学字符识别，是指通过扫描字符，然后通过其形状将其翻译成电子文本的过程

`tesserocr`是Python的一个OCR识别库，但其实是对`tesseract`做的一层Python API封装，所以它的核心是`tesseract`。因此，在安装`tesserocr`之前，我们需要先安装[`tesseract`](https://github.com/tesseract-ocr/tesseract)。




You will need the Python Imaging Library (PIL) (or the Pillow fork). Under Debian/Ubuntu, this is the package python-imaging or python3-imaging.

Install [Google Tesseract OCR](https://github.com/tesseract-ocr/tesseract) (additional info how to install the engine on Linux, Mac OSX and Windows). You must be able to invoke the tesseract command as tesseract. If this isn't the case, for example because tesseract isn't in your PATH, you will have to change the "tesseract_cmd" variable `pytesseract.pytesseract.tesseract_cmd`. 

Under Debian/Ubuntu you can use the package `tesseract-ocr`. 

For Mac OS users. please install homebrew package `tesseract`.

## Install

CentOS

```
yum install -y tesseract
```

MAC

```
brew install imagemagick 
brew install tesseract --all-languages
pip3 install tesserocr pillow
```

## Example

```
import tesserocr
from PIL import Image
image = Image.open('image.png')
print(tesserocr.image_to_text(image))
```

## 参考
* [Docs](https://selenium-python.readthedocs.io/index.html)
* [pytesseract](https://github.com/madmaze/pytesseract)
* [Google Tesseract OCR](https://github.com/tesseract-ocr/tesseract)

tesseract

* [tesseract GitHub](https://github.com/tesseract-ocr/tesseract)
* [tesseract语言包](https://github.com/tesseract-ocr/tessdata)
* [tesseract文档](https://github.com/tesseract-ocr/tesseract/wiki/Documentation)