#include <cmath>
#include <ctime>
#include <future>
#include <iostream>
#include <sstream>
#include <stdexcept>

using namespace std;

// Точность вычислений
#define EPSILON 1e-6

// Объявление типа для удобного создания массива функций
typedef double (*DoubleFunctionWithOneParameter)(double a);

// Математические функции
double f1(double x) { return x * x; }
double f2(double x) { return x; }
double f3(double x) { return sin(x); }
double f4(double x) { return tan(x); }
double f5(double x) { return 2 * x + 5; }

// Основная рекурсия.
// Аргументы:
// double left, right: границы интервала по оси X.
// double fleft, fright: значения функции f(x) на границах интервала (передаём
// эти значения в рекурсию чтобы не считать их лишний раз)
// double lrarea: приблизительное значение площади,
// вычисленное методом трапеций на предыдущем шагу рекурсии.
// double f(double x): функция f(x), относительно которой считаются значения.
double quad(double left, double right, double fleft, double fright,
            double lrarea, double f(double)) {
  double mid = (left + right) / 2; // Находим среднюю точку интервала
  double fmid = f(mid); // Находим значение функции в средней точке
  double larea = (fleft + fmid) * (mid - left) /
                 2; // Находим приблизительную площадь левой части интервала
                    // (метод трапеций)
  double rarea = (fmid + fright) * (right - mid) /
                 2; // Находим приблизительную площадь правой части
  if (abs(larea + rarea - lrarea) >
      EPSILON) { // Если разница между значением, вычисленным на предыдущем шагу
                 // и на текущем больше, чем заданная точность, уточням.
    future<double> larea_promise =
        async(&quad, left, mid, fleft, fmid, larea,
              f); // Рекурсивно считаем площадь левой половины
    future<double> rarea_promise =
        async(&quad, mid, right, fmid, fright, rarea,
              f); // Рекурсивно считаем площадь правой половины
    // Ждём выполнения асинхронной рекурсии и получаем результаты.
    larea = larea_promise.get();
    rarea = rarea_promise.get();
  }
  return rarea + larea; // Возвращаем полученное значение.
}

// Функция-хелпер для более очевидного вызова рекурсии.
double quad(double left, double right, double f(double)) {
  return quad(left, right, f(left), f(right),
              (f(left) + f(right)) * (right - left) / 2, f);
}

int main(int argc, char *argv[]) {
  double a, b;
  int fn = 0;
  DoubleFunctionWithOneParameter funcs[] = {f1, f2, f3, f4, f5};

  // Парсим аргументы командной строки
  try {
    if (argc != 3 && (argc != 5))
      throw invalid_argument("Invalid argument count");
    stringstream ss;
    for (int i = 1; i < argc; ++i)
      ss << argv[i] << " ";
    ss.flush();
    ss.seekg(0);
    ss >> a >> b;
    if (argc == 5) {
      string tmp;
      ss >> tmp;
      ss >> fn;
      fn--;
      if (fn < 0 || fn > 4)
        throw invalid_argument("Invalid function_number. Valid values: 1-5");
    }
  } catch (exception &e) {
    cerr << "Invalid usage: " << e.what() << ". Try:" << endl;
    cerr << argv[0] << " <left_bound> <right_bound> [-f <function_number>]"
         << endl;
    return -1;
  }

  // Вызов рекурсии и вывод ответа
  cout << quad(a, b, funcs[fn]) << endl;
  return 0;
}
