#!/bin/bash

LB_ADDR="10.67.4.3"

RR_IP="8000"    # IP Round Robin
IPH_IP="8001"   # IP IP Hash
GENH_IP="8002"  # IP Generic Hash

LC3W_IP="8003"  # IP Least Conn 3 Workers
LC2W_IP="8004"  # IP Least Conn 2 Workers
LC1W_IP="8005"  # IP Least Conn 1 Worker

mkdir -p /root/report

RoundRobinTest() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$RR_IP\/)" > /root/report/round_robin_test.bin
  echo "Round Robin Test Done"
}

IPHashTest() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$IPH_IP\/)" > /root/report/ip_hash_test.bin
  echo "IP Hash Test Done"
}

GenHashTest() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$GENH_IP\/)" > /root/report/gen_hash_test.bin
  echo "Generic Hash Test Done"
}

LeastConn3Test() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$LC3W_IP\/)" > /root/report/least_conn_3_test.bin
  echo "Least Connection with 3 Workers Test Done"
}

LeastConn2Test() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$LC2W_IP\/)" > /root/report/least_conn_2_test.bin
  echo "Least Connection with 2 Workers Test Done"
}

LeastConn1Test() {
  AMT=$1
  CON=$2

  echo "$(ab -n $AMT -c $CON http:\/\/$LB_ADDR:$LC1W_IP\/)" > /root/report/least_conn_1_test.bin
  echo "Least Connection with 1 Worker Test Done"
}

SingleTest() {
  echo "
========== Single Test ==========

Pilih Load Balancer:

1.) Round Robin - 3 Workers
2.) IP Hash - 3 Workers
3.) Generic Hash - 3 Workers
4.) Least Connection - 3 Workers
5.) Least Connection - 2 Workers
6.) Least Connection - 1 Workers
"

  echo -n "Pilih Opsi Pengujian: "
  read optLB

  if [ $optLB -eq 1 ];
  then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    RoundRobinTest $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t Round Robin"
    echo -e "Jumlah Worker: \t\t 3 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Round Robin\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/round_robin_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  elif [ $optLB -eq 2 ]; then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    IPHashTest $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t IP Hash"
    echo -e "Jumlah Worker: \t\t 3 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "IP Hash\t\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/ip_hash_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  elif [ $optLB -eq 3 ]; then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    GenHashTest $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t Generic Hash"
    echo -e "Jumlah Worker: \t\t 3 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Generic Hash\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/gen_hash_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  elif [ $optLB -eq 4 ]; then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    LeastConn3Test $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t Least Connection"
    echo -e "Jumlah Worker: \t\t 3 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_3_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  elif [ $optLB -eq 5 ]; then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    LeastConn2Test $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t Least Connection"
    echo -e "Jumlah Worker: \t\t 2 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t2\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_2_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  elif [ $optLB -eq 6 ]; then
    echo -n "Masukkan Jumlah Request: "
    read inReq
    echo -n "Masukkan Jumlah Concurrency: "
    read inCon

    LeastConn1Test $inReq $inCon

    echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
    echo -e "\nKeterangan Pengujian"
    echo -e "Nama Load Balancer: \t LEast Connection"
    echo -e "Jumlah Worker: \t\t 1 Workers"

    echo -e "\nTabel Hasil\n"
    # Menampilkan header tabel
    echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

    # Mengambil data dari file
    awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t1\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_1_test.bin
    echo -e "\n\n+++++ Akhir Laporan +++++\n"
  else
    echo "Unknown Input"
  fi
}

MultiTestLB() {
  echo "
========== Multi Test - By LB Method ==========

"
  echo -n "Masukkan Jumlah Request: "
  read inReq
  echo -n "Masukkan Jumlah Concurrency: "
  read inCon

  RoundRobinTest $inReq $inCon
  sleep 1
  IPHashTest $inReq $inCon
  sleep 1
  GenHashTest $inReq $inCon
  sleep 1
  LeastConn3Test $inReq $inCon

  echo "Multi Test Done"

  echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
  echo -e "\nKeterangan Pengujian"
  echo -e "Nama Load Balancer: \t Round Robin, Least Connection, IP Hash, dan Generic Hash"
  echo -e "Jumlah Worker: \t\t 3 Workers"

  echo -e "\nTabel Hasil\n"
  # Menampilkan header tabel
  echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

  # Mengambil data dari file
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Round Robin\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/round_robin_test.bin
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_3_test.bin
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "IP Hash\t\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/ip_hash_test.bin
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Generic Hash\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/gen_hash_test.bin
  echo -e "\n\n+++++ Akhir Laporan +++++\n"
}

MultiTestWorker() {
  echo "
========== Multi Test - By Worker Amount ==========

"

  echo -n "Masukkan Jumlah Request: "
  read inReq
  echo -n "Masukkan Jumlah Concurrency: "
  read inCon

  LeastConn3Test $inReq $inCon
  sleep 1
  LeastConn2Test $inReq $inCon
  sleep 1
  LeastConn1Test $inReq $inCon
  sleep 1
  
  echo "Multi Test Done"

  echo -e "\n\n+++++ Laporan Hasil Pengujian Load Balancer +++++"
  echo -e "\nKeterangan Pengujian"
  echo -e "Nama Load Balancer: \t Round Robin, Least Connection, IP Hash, dan Generic Hash"
  echo -e "Jumlah Worker: \t\t 3 Workers"

  echo -e "\nTabel Hasil\n"
  # Menampilkan header tabel
  echo -e "Load Balancer\tWorker(s)\tReq per second\tComplete req\tFailed req\tTime per req\tTransfer rate"

  # Mengambil data dari file
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t3\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_3_test.bin
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t2\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_2_test.bin
  awk '/Requests per second/{req_sec=$(NF-2)} /Complete requests/{comp_req=$NF} /Failed requests/{fail_req=$NF} /Time per request/{time_req=$(NF-6)} /Transfer rate/{transfer_rate=$(NF-2)} END {printf "Least Conn\t1\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\n", req_sec, comp_req, fail_req, time_req, transfer_rate}' /root/report/least_conn_1_test.bin
  echo -e "\n\n+++++ Akhir Laporan +++++\n"
}

echo "
========== Apache Benchmarking ==========
             By Jarkom-IT07

Opsi Pengujian Load Balancer:

1.) Single Test
2.) Multi Test - By LB Method
3.) Multi Test - By Worker Amount

"

echo -n "Pilih Opsi Pengujian: "
read optLB

if [ $optLB -eq 1 ];
then
  SingleTest
elif [ $optLB -eq 2 ]; then
  MultiTestLB
elif [ $optLB -eq 3 ]; then
  MultiTestWorker
else
  echo "Unknown Input"
fi