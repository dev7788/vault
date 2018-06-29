target=$1

echo 'Target: ' $target

# Clear the content of the output file (or create)
echo '' > $target

# The order of this array dictates the order that the tables/functions/data will be created in the database.
files=( ../sql/common/pre/*.sql ../sql/concept/tables/*.sql ../sql/concept/data/*.sql ../sql/concept/views/*.sql ../sql/concept/functions/*.sql ../sql/indicator/functions/*.sql ../sql/common/post/*.sql)

# Loop through all of the files and append them to the target file.
for source in ${files[@]}
do
  [ -e "$source" ] || continue
  echo 'Source: ' $source

  echo '' >> $target
  echo '--------------------------------------------------------------------------------------------' >> $target
  echo '-- Source: ' $source >> $target
  echo '--------------------------------------------------------------------------------------------' >> $target
  cat $source >> $target
done
