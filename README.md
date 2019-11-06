# EUI-for-MAC
仅适用于WOW怀旧版的EUI的MAC版本，有需求的朋友，放入收藏夹，或者star一下，算是给作者的支持的同时，可以让作者给E大推广的理由

## 新手办法
1. 在本仓库首页，点击`Clone or download`，接着点击`Download ZIP`
2. 将下载下来的zip包解压至WOW怀旧服的`_classic_`文件夹下（__首次使用，需删除Cache，Fonts，Interface和WTF__）

## 懒人方法（进阶）
### 准备
1. 下载git客户端（貌似mac默认就装的，可以试试看本地可否执行git）
2. 注册github账号

### 首次
1. 进入`/Applications/World of Warcraft/_classic_`（取决于你安装目录，此为默认路径）
```sh
cd /Applications/World\ of\ Warcraft/_classic_
```
2. 用命令行执行以下命令
```sh
git init
git remote add origin https://github.com/tiller2008/_classic_.git（如果在github上关联过ssh的话可以执行如下命令：git remote add origin git@github.com:tiller2008/_classic_.git）
git fetch
git branch master origin/master
git checkout master
```
> 首次执行相对较慢，需耐心（取决于您的网速）
> 如果中间执行失败的话，可以`rm -rf .git`重新执行一遍

### 以后
1. 在wow安装目录`/Applications/World of Warcraft/_classic_`
```sh
cd /Applications/World\ of\ Warcraft/_classic_
```
2. 只需要执行一次命令
```sh
git pull
```
