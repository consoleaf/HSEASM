#include "main.h"
#include "database.h"
#include <algorithm>
#include <stdexcept>

using namespace std;

Database::Database() {
  printf("%s %s\n", time().c_str(), "Database initialized");
}

Database::~Database() {
  printf("%s %s\n", time().c_str(), "Database destructed");
}

const int Database::index(const int key) const {
  auto iter = find(__keys.begin(), __keys.end(), key);
  if (iter == __keys.end())
    return -1;
  return iter - __keys.begin();
}

const bool Database::has(const int key) const { return index(key) != -1; }

const int Database::get(const int key) const {
  const int idx = index(key);
  if (idx == -1)
    throw runtime_error("Key not present");
  return __values[idx];
}

const void Database::set(const int key, const int value) {
  printf("%s Setting %d to %d\n", time().c_str(), key, value);
  const int idx = index(key);
  if (idx == -1) {
    __keys.push_back(key);
    __values.push_back(value);
  } else {
    __values[idx] = value;
  }
}

const vector<int> Database::keys() const { return __keys; }
