# EUI-for-MAC
仅适用于WOW怀旧版的EUI的MAC版本，有需求的朋友

## 新手办法
在本仓库首页，点击`Clone or download`，接着点击`Download ZIP`，将下载下来的zip包解压至WOW怀旧服的`_classic_`文件夹下（首次使用，需删除Cache，Fonts，Interface和WTF）
![IMAGE](quiver-image-url/E704BC66699656AD414DA8219E9BB863.jpg =361x234)

## 懒人方法（进阶）
### 准备：下载git客户端（貌似mac默认就装的，可以试试看本地可否执行git）

### 首次
进入`/Applications/World of Warcraft/_classic_`（取决于你安装目录，此为默认路径），用命令行执行以下命令
```sh
git init
git remote add origin git@github.com:tiller2008/_classic_.git（或者git remote add origin https://github.com/tiller2008/_classic_.git）
git fetch
git branch master origin/master
git checkout master
```
> 首次执行相对较慢，需耐心

### 以后
只需要执行一次命令，在wow安装目录`/Applications/World of Warcraft/_classic_`
```sh
git pull
```
