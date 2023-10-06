class History {
  List<String> nama = ["Kelvyn", "Steven", "Nathaniel"];
  List<String> money = ["+ Rp 69.277", "- Rp 77.989", "+ 46.233"];
  List<String> date = [
    "28 September 2023, 13:32",
    "29 September 2023, 13:31",
    "30 September 2023, 11:31"
  ];

  void addHistory(String newNama, String newMoney, String newDate) {
    nama.add(newNama);
    money.add(newMoney);
    date.add(newDate);
  }
}

class Balance {
  int balance = 0;

  void addMoney(int balance) {
    this.balance += balance;
  }
  void deductMoney(int balance) {
    this.balance -= balance;
  }
}


//contoh
// void main() {
//   History myHistory = History();
  
//   // Adding new data
//   myHistory.addHistory("John", "- Rp 50.00", "30 September 2023, 14:00");
// }
