#pragma once
#include "header.h"
#include "HealthRecord.h"

#define RECORDS_FILE "health_records.txt"

class MedicalSystem {
private:
    vector<HealthRecord> records;
    string fileName;
public:
    MedicalSystem(const string& filename);
    void welcomeScreen(); // Giao diện 
    void title();         // 
    void loginScreen();   // Đăng nhập
    void mainMenu();      // Các lựa chọn
    
    void addRecord();     // Thêm một bản ghi vào danh sách
    void listRecords();   // Danh sách các bản ghi
    void editRecord();    // Sửa bản ghi 
    void searchRecord();  // Tìm bản ghi
    
    void searchByPatientID(); // Tìm kiếm theo ID của bệnh nhân
    void searchByDate();      // Tìm kiếm theo Ngày
    void searchByDisease();   // Tìm kiếm theo bệnh
    void searchByRecordID();  // Tìm kiếm theo ID của bản ghi

    void saveToFile();       // Lưu vào file
    void readFromFile();     // Đọc dữ liệu từ file
    void removeRecordByID(); // Xóa một bản ghi
};
MedicalSystem::MedicalSystem(const string& filename) : fileName(RECORDS_FILE) {
    readFromFile();
}

void MedicalSystem::welcomeScreen() {
    cout << "\n\n\n\n\n\n\n";
    cout << "\t\t\t\t#########################################\n";
    cout << "\t\t\t\t#\t\t WELCOME TO\t\t#\n";
    cout << "\t\t\t\t#          HOSPITAL RECORD SYSTEM       #\n";
    cout << "\t\t\t\t#########################################\n";
    cout << "\n\n\n\n\n Press any key to continue......\n";
    cin.get();
    system("cls");
}

void MedicalSystem::title() {
    cout << "\n\n\t\t\t--------------------------------------------------\n";
    cout << "\t\t\t\t       HOSPITAL RECORD\n";
    cout << "\t\t\t--------------------------------------------------\n";
}

void MedicalSystem::mainMenu() {
    int choice;
    do {
        system("cls");
        title();
        cout << "\n\n\n\n\n";
        cout << "\t\t\t\t1. Add Patient Record\n";
        cout << "\t\t\t\t2. List Patient Records\n";
        cout << "\t\t\t\t3. Search Patient Record\n";
        cout << "\t\t\t\t4. Edit Patient Record\n";
        cout << "\t\t\t\t5. Delete Patient Record\n";
        cout << "\t\t\t\t6. Exit\n";
        cout << "\n\n\n \n\t\t\t\tChoose from 1 to 6: ";
        cin >> choice;
        switch (choice) {
            case 1:
                addRecord();
                break;
            case 2:
                listRecords();
                break;
            case 3:
                searchRecord();
                break;
            case 4:
                editRecord();
                break;
            case 5:
                removeRecordByID();
                break;
            case 6:
                system("cls");
                exit(0);
            default:
                system("cls");
                cout << "\t\t\tInvalid entry. Please enter the right option :)\n";
                cin.ignore();
        }
        cout << endl << "\t\t\t-------------------------" << endl;
        cout << "\t\t\tPress any key to continue." << endl;
        cin.get();
        mainMenu();
    } while (choice != 6);
}

void MedicalSystem::loginScreen() {
    int attempts = 0;
    string username, password;
    const string originalUsername = "admin";
    const string originalPassword = "12345";

    do {
        cout << "\n\n\n\n\t\t\t\tEnter your Username and Password :)\n";
        cout << "\n\n\n\t\t\t\t\tUSERNAME: ";
        cin >> username;

        cout << "\n\n\t\t\t\t\tPASSWORD: ";
        cin >> password;

        if (username == originalUsername && password == originalPassword) {
            cout << "\n\n\n\t\t\t\t\t...Login Successful...\n";
            cin.get();
            mainMenu();
            break;
        } else {
            cout << "\n\t\t\tPassword is incorrect. Try Again :)\n";
            attempts++;
            cin.get();
        }
    } while (attempts <= 2);

    if (attempts > 2) {
        cout << "You have crossed the limit. You cannot login. :(\n";
        cin.get();
        exit(0);
    }
}

void MedicalSystem::saveToFile() {
    // Mở tập tin OUTPUT_FILE để ghi dữ liệu.
    ofstream outputFile(RECORDS_FILE);

    // Kiểm tra xem việc mở tập tin có thành công hay không.
    if (!outputFile) {
        cout << "Error opening file." << endl;
        return;
    }

    // Ghi tiêu đề của các cột thông tin vào tập tin.
    outputFile << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
               << "Date" << setw(20) << "Disease" << endl;

    // Ghi dòng ngăn cách bằng ký tự "=" để tạo đường ngăn cách giữa tiêu đề và dữ liệu.
    outputFile << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Duyệt qua từng bản ghi trong danh sách các bản ghi (records).
    for (const auto& record : records) {
        // Ghi thông tin của mỗi bản ghi vào tập tin, với định dạng cột được căn lề bên trái và độ rộng cố định cho mỗi cột.
        outputFile << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
    }

    // Đóng tập tin sau khi ghi xong.
    outputFile.close();
}


void MedicalSystem::readFromFile() {
    // Mở tập tin INPUT_FILE để đọc dữ liệu.
    ifstream inputFile(RECORDS_FILE);

    // Kiểm tra xem việc mở tập tin có thành công hay không.
    if (!inputFile) {
        cout << "Error opening file." << endl;
        return;
    }

    // Đọc tiêu đề của các cột thông tin từ tập tin và lưu vào biến `headerLine`.
    string headerLine;
    getline(inputFile, headerLine);

    // Đọc dòng ngăn cách từ tập tin và lưu vào biến `separatorLine`.
    string separatorLine;
    getline(inputFile, separatorLine);

    // Biến để lưu thông tin của mỗi bản ghi được đọc từ tập tin.
    string patientID, patientName, recordID, date, disease;

    // Duyệt qua từng dòng trong tập tin (mỗi dòng chứa thông tin của một bản ghi).
    // Vòng lặp sẽ tiếp tục cho đến khi không thể đọc thêm thông tin nào nữa từ tập tin.
    while (inputFile >> patientID >> patientName >> recordID >> date >> disease) {
        // Sau khi đọc thông tin của một bản ghi, ta tạo một đối tượng `HealthRecord` mới
        // với các thông tin đã đọc được và sau đó thêm đối tượng này vào vector `records`.
        HealthRecord newRecord(patientID, patientName, recordID, date, disease);
        records.push_back(newRecord);
    }

    // Đóng tập tin sau khi đọc xong.
    inputFile.close();
}


void MedicalSystem::listRecords() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Hiển thị tiêu đề "HOSPITAL RECORD".
    title();

    // Loại bỏ ký tự newline còn tồn đọng trong buffer (nếu có) sau khi người dùng nhập lựa chọn trong menu trước đó.
    cin.ignore();

    // Hiển thị tiêu đề "Patient Records".
    cout << "Patient Records:" << endl;

    // Hiển thị dòng ngăn cách bằng ký tự "=" để tạo đường ngăn cách giữa tiêu đề và danh sách các bản ghi.
    cout << "----------------------" << endl;
    cout << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
         << "Date" << setw(20) << "Disease" << endl;
    cout << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Kiểm tra nếu danh sách bản ghi (records) là trống.
    if (records.empty()) {
        // Nếu danh sách rỗng, hiển thị thông báo "No records found."
        cout << "No records found." << endl;
    } else {
        // Nếu danh sách không rỗng, duyệt qua từng bản ghi trong danh sách và hiển thị thông tin của từng bản ghi.
        for (const auto& record : records) {
            cout << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
        }
    }
}


void MedicalSystem::editRecord() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập record ID cần chỉnh sửa.
    string searchRecordID;
    cout << "Enter record ID to edit: ";
    cin.ignore();
    getline(cin, searchRecordID);

    // Biến bool `found` để kiểm tra xem record có tồn tại trong danh sách không.
    bool found = false;

    // Duyệt qua từng bản ghi trong danh sách bằng vòng lặp `for`.
    for (auto& record : records) {
        // So sánh record ID của từng bản ghi với record ID mà người dùng nhập vào.
        if (record.getRecordID() == searchRecordID) {
            // Nếu record ID trùng khớp, đánh dấu là đã tìm thấy.
            found = true;

            // Hiển thị thông tin của bản ghi cần chỉnh sửa.
            cout << "Editing Record ID: " << record.getRecordID() << endl;

            // Yêu cầu người dùng nhập thông tin mới cho bản ghi.
            cout << "Enter new patient ID: ";
            string newPatientID;
            getline(cin, newPatientID);
            record.setPatientID(newPatientID);

            cout << "Enter new patient name: ";
            string newPatientName;
            getline(cin, newPatientName);
            record.setPatientName(newPatientName);

            cout << "Enter new date: ";
            string newDate;
            getline(cin, newDate);
            record.setDate(newDate);

            cout << "Enter new disease: ";
            string newDisease;
            getline(cin, newDisease);
            record.setDisease(newDisease);

            // Hiển thị thông báo xác nhận và cập nhật thông tin thành công.
            cout << "Record updated successfully!" << endl;

            // Gọi phương thức `saveToFile()` để cập nhật thông tin vào tập tin sau khi chỉnh sửa bản ghi.
            saveToFile();
            
            // Dừng vòng lặp sau khi đã tìm thấy bản ghi cần chỉnh sửa.
            break;
        }
    }

    // Nếu không tìm thấy bản ghi với record ID mà người dùng nhập vào, hiển thị thông báo không tìm thấy.
    if (!found) {
        cout << "No records found for the given record ID." << endl;
    }
}



void MedicalSystem::addRecord() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Khai báo các biến để lưu thông tin của bệnh nhân mới.
    string patientID, patientName, recordID, date, disease;

    // Yêu cầu người dùng nhập thông tin của bệnh nhân mới.
    cout << "Enter patient ID: ";
    cin >> patientID;
    cout << "Enter patient name: ";
    cin.ignore();
    getline(cin, patientName);

    // Kiểm tra xem có bệnh nhân nào khác có cùng patient ID nhưng tên khác nhau không.
    // Nếu có, thông báo lỗi và không cho phép thêm bệnh nhân mới.
    for (const auto& record : records) {
        if (record.getPatientID() == patientID) {
            if (record.getPatientName() != patientName) {
                cout << "Invalid: A patient with the same patient ID exists, but the patient name does not match." << endl;
                return;
            }
            break;
        }
    }

    // Nếu bệnh nhân có patient ID và tên phù hợp, tiếp tục thêm bệnh nhân mới vào hệ thống.

    // Tạo record ID mới cho bệnh nhân mới. Nếu danh sách records rỗng, gán record ID là 1.
    // Ngược lại, lấy record ID của bản ghi cuối cùng trong danh sách, tăng giá trị lên 1 và gán vào record ID mới.
    int nextRecordID = records.empty() ? 1 : stoi(records.back().getRecordID()) + 1;
    recordID = to_string(nextRecordID);

    // Yêu cầu người dùng nhập date và disease cho bệnh nhân mới.
    cout << "Enter date: ";
    getline(cin, date);
    cout << "Enter disease: ";
    getline(cin, disease);

    // Tạo một bản ghi mới với thông tin của bệnh nhân và thêm vào danh sách records.
    HealthRecord newRecord(patientID, patientName, recordID, date, disease);
    records.push_back(newRecord);

    // Hiển thị thông báo xác nhận và cập nhật thành công.
    cout << "Record added successfully!" << endl;

    // Gọi phương thức `saveToFile()` để cập nhật thông tin vào tập tin sau khi thêm bệnh nhân mới.
    saveToFile();
}


void MedicalSystem::removeRecordByID() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập record ID của bản ghi cần xóa.
    string removeRecordID;
    cout << "Enter record ID to remove: ";
    cin.ignore();
    getline(cin, removeRecordID);

    // Tạo biến boolean `found` để kiểm tra xem có bản ghi với `record ID` cần xóa không.
    bool found = false;

    // Duyệt qua danh sách records bằng vòng lặp for.
    for (auto i = records.begin(); i != records.end(); ++i) {
        // So sánh `record ID` của bản ghi hiện tại với `record ID` cần xóa.
        if (i->getRecordID() == removeRecordID) {
            // Nếu `record ID` trùng khớp, sử dụng phương thức `erase()` để xóa bản ghi khỏi danh sách.
            records.erase(i);
            // Gán `found` thành true để biểu thị rằng đã tìm thấy và xóa bản ghi.
            found = true;
            // Dừng vòng lặp vì đã tìm thấy bản ghi và xóa thành công.
            break;
        }
    }

    // Kiểm tra nếu `found` là true, tức là đã tìm thấy và xóa bản ghi.
    if (found) {
        cout << "Record with record ID " << removeRecordID << " removed successfully." << endl;
        // Gọi phương thức `saveToFile()` để cập nhật thông tin vào tập tin sau khi xóa bản ghi.
        saveToFile();
    } else {
        // Nếu không tìm thấy bản ghi với `record ID` cần xóa, hiển thị thông báo không tìm thấy.
        cout << "No records found for the given record ID." << endl;
    }
}


void MedicalSystem::searchByPatientID() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập patient ID cần tìm kiếm.
    string searchPatientID;
    cout << "Enter patient ID: ";
    cin.ignore();
    getline(cin, searchPatientID);

    // Tạo biến boolean `found` để kiểm tra xem có bản ghi với `patient ID` cần tìm kiếm không.
    bool found = false;

    // Hiển thị tiêu đề cho kết quả tìm kiếm.
    cout << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
         << "Date" << setw(20) << "Disease" << endl;
    cout << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Duyệt qua danh sách records bằng một vòng lặp for-each.
    for (const auto& record : records) {
        // So sánh `patient ID` của bản ghi hiện tại với `patient ID` cần tìm kiếm.
        if (record.getPatientID() == searchPatientID) {
            // Nếu `patient ID` trùng khớp, hiển thị thông tin của bản ghi.
            cout << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
            // Đánh dấu biến `found` thành true để biểu thị rằng đã tìm thấy bản ghi.
            found = true;
        }
    }

    // Kiểm tra nếu `found` là false, tức là không tìm thấy bản ghi với `patient ID` cần tìm kiếm.
    if (!found) {
        cout << "No records found for the given patient ID." << endl;
    }
}


void MedicalSystem::searchByRecordID() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập record ID cần tìm kiếm.
    string searchRecordID;
    cout << "Enter record ID: ";
    cin.ignore();
    getline(cin, searchRecordID);

    // Tạo biến boolean `found` để kiểm tra xem có bản ghi với `record ID` cần tìm kiếm không.
    bool found = false;

    // Hiển thị tiêu đề cho kết quả tìm kiếm.
    cout << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
         << "Date" << setw(20) << "Disease" << endl;
    cout << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Duyệt qua danh sách records bằng một vòng lặp for-each.
    for (const auto& record : records) {
        // So sánh `record ID` của bản ghi hiện tại với `record ID` cần tìm kiếm.
        if (record.getRecordID() == searchRecordID) {
            // Nếu `record ID` trùng khớp, hiển thị thông tin của bản ghi.
            cout << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
            // Đánh dấu biến `found` thành true để biểu thị rằng đã tìm thấy bản ghi.
            found = true;
        }
    }

    // Kiểm tra nếu `found` là false, tức là không tìm thấy bản ghi với `record ID` cần tìm kiếm.
    if (!found) {
        cout << "No records found for the given record ID." << endl;
    }
}


void MedicalSystem::searchByDate() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập ngày cần tìm kiếm.
    string searchDate;
    cout << "Enter date: ";
    cin.ignore();
    getline(cin, searchDate);

    // Tạo biến boolean `found` để kiểm tra xem có bản ghi nào trùng khớp với `date` cần tìm kiếm không.
    bool found = false;

    // Hiển thị tiêu đề cho kết quả tìm kiếm.
    cout << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
         << "Date" << setw(20) << "Disease" << endl;
    cout << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Duyệt qua danh sách records bằng một vòng lặp for-each.
    for (const auto& record : records) {
        // So sánh ngày (`date`) của bản ghi hiện tại với `searchDate`.
        if (record.getDate() == searchDate) {
            // Nếu ngày trùng khớp, hiển thị thông tin của bản ghi.
            cout << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
            // Đánh dấu biến `found` thành true để biểu thị rằng đã tìm thấy bản ghi.
            found = true;
        }
    }

    // Kiểm tra nếu `found` là false, tức là không tìm thấy bản ghi nào trùng khớp với `date` cần tìm kiếm.
    if (!found) {
        cout << "No records found for the given date." << endl;
    }
}


void MedicalSystem::searchByDisease() {
    // Xóa màn hình console để hiển thị màn hình trống.
    system("cls");

    // Yêu cầu người dùng nhập tên bệnh cần tìm kiếm.
    string searchDisease;
    cout << "Enter disease: ";
    cin.ignore();
    getline(cin, searchDisease);

    // Tạo biến boolean `found` để kiểm tra xem có bản ghi nào trùng khớp với tên bệnh cần tìm kiếm không.
    bool found = false;

    // Hiển thị tiêu đề cho kết quả tìm kiếm.
    cout << left << setw(20) << "Patient ID" << setw(30) << "Patient Name" << setw(15) << "Record ID" << setw(15)
         << "Date" << setw(20) << "Disease" << endl;
    cout << setfill('=') << setw(100) << "" << setfill(' ') << endl;

    // Duyệt qua danh sách records bằng một vòng lặp for-each.
    for (const auto& record : records) {
        // So sánh tên bệnh (`disease`) của bản ghi hiện tại với `searchDisease`.
        if (record.getDisease() == searchDisease) {
            // Nếu tên bệnh trùng khớp, hiển thị thông tin của bản ghi.
            cout << left << setw(20) << record.getPatientID() << setw(30) << record.getPatientName() << setw(15)
                 << record.getRecordID() << setw(15) << record.getDate() << setw(20) << record.getDisease() << endl;
            // Đánh dấu biến `found` thành true để biểu thị rằng đã tìm thấy bản ghi.
            found = true;
        }
    }

    // Kiểm tra nếu `found` là false, tức là không tìm thấy bản ghi nào trùng khớp với tên bệnh cần tìm kiếm.
    if (!found) {
        cout << "No records found for the given disease." << endl;
    }
}


void MedicalSystem::searchRecord() {
    system("cls");
    int choice;
    title();
    cout << "\n\n\n\n\n";
    cout << "\t\t\t\t1. Search by Record ID\n";
    cout << "\t\t\t\t2. Search by Patient ID\n";
    cout << "\t\t\t\t3. Search by Date\n";
    cout << "\t\t\t\t4. Search by Disease\n";
    cout << "\t\t\t\t5. Back to Main Menu\n";
    cout << "\n\n\n \n\t\t\t\tChoose from 1 to 5: ";
    cin >> choice;

    switch (choice) {
        case 1:
            searchByRecordID();
            break;
        case 2:
            searchByPatientID();
            break;
        case 3:
            searchByDate();
            break;
        case 4:
            searchByDisease();
            break;
        case 5:
            mainMenu();
            break;
        default:
            cout << "\t\t\tInvalid entry. Please enter the right option :)\n";
            cin.ignore();
            cin.get();
            searchRecord();
    }
}
