#!/bin/bash -x

uri_pattern="/new_items/.+\.json,/items/.+\.json,/users/.+\.json,/transactions/.+\.png"

now=`date +%H%M`
tmp_dir=tmp/$now

if [ ! -d $tmp_dir ]; then
  mkdir -p $tmp_dir
fi

for host in isu-app-01; do
  scp $host:/var/log/nginx/access.log $tmp_dir/access.log.$host.tmp
  grep ua:benchmarker $tmp_dir/access.log.$host.tmp | grep -v 'xtime:-' >> $tmp_dir/access.log.tmp
done

xtime_idx=`head -1 $tmp_dir/access.log.tmp | ruby -ne 'puts $_.split.index{|x|x=~/^xtime:/}'`
sort -k$xtime_idx -t$'\t' $tmp_dir/access.log.tmp > $tmp_dir/access.log
first_line_no=`grep -n uri:/initialize $tmp_dir/access.log | tail -1 | cut -f1 -d:`
sed -i .bak -e "1,${first_line_no}d" $tmp_dir/access.log

rm $tmp_dir/access.log.*

cat $tmp_dir/access.log | alp ltsv -r -q --sort=sum -m $uri_pattern > $tmp_dir/alp.txt

scp $host:/var/lib/mysql/mysql-slow.log $tmp_dir/

if [ ! -f tmp/pt-query-digest ]; then
  curl -o tmp/pt-query-digest https://www.percona.com/get/pt-query-digest
  chmod 755 tmp/pt-query-digest
fi

tmp/pt-query-digest $tmp_dir/mysql-slow.log > $tmp_dir/slow.txt