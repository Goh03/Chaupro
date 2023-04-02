#include <stdio.h>
#include <string.h>
enum Days{Mon=2,Tue,Wed,Thur=7,Fri,Sat,Sun=1};
enum Months{Jan=1,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec};
typedef struct dob{
    int d;
    enum Months m;
    int y;
} dob;
typedef struct student {
    char name[10];
    int ID;
    float score;
    struct dob date;
}STD ;
int main(){
    STD s {"GOH",20213601,3.9,{3,Feb,2003}};
    printf("Student Information:\n");
    printf("Name : %s\n",s.name);
    printf("ID   : %d\n",s.ID);
    printf("Score: %.1f\n",s.score);
    printf("Dob  : %d/%d/%d",s.date.d,s.date.m,s.date.y);

}
