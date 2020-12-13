#ifndef __DATABASE_H_
#define __DATABASE_H_
#include <vector>

using namespace std;

class Database {
private:
  vector<int> __keys;
  vector<int> __values;

  const int index(const int key) const;

public:
    Database();
    ~Database();
  const int get(const int key) const;
  const void set(const int key, const int value);
  const bool has(const int key) const;
  const vector<int> keys() const;
};

#endif // __DATABASE_H_
