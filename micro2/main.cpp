#include "main.h"
#include "database.h"
#include <condition_variable>
#include <mutex>
#include <stdio.h>
#include <thread>

using namespace std;

mutex time_lock;
condition_variable time_cv;
bool time_ready = true;
int time_count = 0;

mutex write_lock;
condition_variable write_cv;
bool write_ready = true;

mutex start_lock;
condition_variable start_cv;
bool start_ready = false;

string time() {
  unique_lock<mutex> lck(time_lock);
  while (!time_ready)
    time_cv.wait(lck);
  time_ready = false;
  time_cv.notify_all();
  string res = "[TIME: " + to_string(time_count++) + "] ==> ";
  time_ready = true;
  time_cv.notify_one();
  return res;
}

struct Writer {
  Database *db;
  int key;
  int value;

  Writer(Database &db, int key, int value) {
    this->db = &db;
    this->key = key;
    this->value = value;
  }

  void operator()() {
    unique_lock<mutex> lckstart(start_lock);
    while (!start_ready) start_cv.wait(lckstart);

    unique_lock<mutex> lck(write_lock);
    while (!write_ready) {
      write_cv.wait(lck);
    }

    write_ready = false;
    write_cv.notify_all();
    printf("%s Locked for writing\n", time().c_str());

    printf("%s Started writeValue(%d, %d)\n", time().c_str(), key, value);
    db->set(key, value);

    write_ready = true;
    write_cv.notify_all();
    printf("%s Unlocked for writing\n", time().c_str());
  }
};

struct Reader {
  Database *db;
  int key;

  Reader(Database &db, int key) {
    this->db = &db;
    this->key = key;
  }

  void operator()() {
    unique_lock<mutex> lckstart(start_lock);
    while (!start_ready) start_cv.wait(lckstart);

    printf("%s Started readValue(%d)\n", time().c_str(), key);
    try {
      auto value = db->get(key);
      printf("%s Got value: %d -> %d\n", time().c_str(), key, value);
    } catch (exception e) {
      printf("%s Value for key %d not found\n", time().c_str(), key);
    }
  }
};

int main(int argc, char *argv[]) {
  printf("%sProgram started\n", time().c_str());
  Database db;

  thread writer1(Writer(db, 1, 2));
  thread writer2(Writer(db, 2, 3));
  thread writer3(Writer(db, 3, 4));
  thread writer4(Writer(db, 4, 5));
  thread reader1(Reader(db, 1));
  thread reader2(Reader(db, 2));
  thread reader3(Reader(db, 3));
  thread reader4(Reader(db, 4));

  start_ready = true;
  start_cv.notify_all();

  writer1.join();
  reader1.join();
  writer2.join();
  reader2.join();
  writer3.join();
  reader3.join();
  writer4.join();
  reader4.join();

  return 0;
}
