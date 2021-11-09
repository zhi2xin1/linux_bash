printf "##############################################\n"
printf "#                                            #\n"
printf "#                7z便捷处理脚本              #\n"
printf "#                                            #\n"
printf "#                 作者：直心                 #\n"
printf "#                 版本：V1.0                 #\n"
printf "#                 时间：2021年11月08日       #\n"
printf "#                                            #\n"
printf "##############################################\n"

printf "\n输入要处理的文件或文件夹的路径：\n"
read ori_path
while [ ! -r "$ori_path" ]
do
  printf "文件或文件夹不存在，请重新输入！\n"
  read ori_path
done

printf "\n如果有同名文件是否要覆盖（输入 y 表示要，默认不要）：\n"
read ao
if [ "$ao" = "y" ] || [ "$pass" = "Y" ]
then
  ao="-aoa"
else
  ao="-aos"
fi

if [ -f "$ori_path" ] && [ "${ori_path##*.}" = "7z" ]
then
  printf "\n输入要解压到的文件夹的路径（类似 ./test/，留空使用默认路径）：\n"
  read newpath
  while [ -n "$newpath" ] && [ "${newpath##*.}" != "7z" ]
  do
    printf "路径不正确，请重新输入！\n"
    read newpath
  done
  if [ -z "$newpath" ] && [ -f "$ori_path" ]
  then
    newpath="`basename $ori_path .${ori_path##*.}`/"
  fi
  ./7zz x $ao -o"$newpath" "$ori_path"
else
  printf "\n是否加密（输入 y 表示加密，默认不加密）：\n"
  read pass
  if [ "$pass" = "y" ] || [ "$pass" = "Y" ]
  then
    pass="-mhe -p"
  else
    pass=""
  fi

  printf "\n输入压缩后的7z文件的路径（类似 ./test/x.7z，留空使用默认路径）：\n"
  read newpath
  while [ -n "$newpath" ] && [ "${newpath##*.}" != "7z" ]
  do
    printf "路径不正确，请重新输入！\n"
    read newpath
  done
  if [ -z "$newpath" ] && [ -f "$ori_path" ]
  then
    newpath="`basename $ori_path .${ori_path##*.}`.7z"
  fi
  if [ -z "$newpath" ] && [ -d "$ori_path" ]
  then
    newpath="`basename $ori_path`.7z"
  fi


  if [ -f "$ori_path" ]
  then
    ./7zz  a $pass $ao "$newpath"  "$ori_path"
  else
    ./7zz  a $pass $ao -r "$newpath"  "$ori_path"
  fi
fi
printf "\n处理完毕！\n"
