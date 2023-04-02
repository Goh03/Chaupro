#include<stdio.h>
struct Date {
    int day;
    int month;
    int year;
};
typedef struct Model {
    long mComputer;
    struct Date date;
    int bQuantity;
    int sQuantity;
    float bPrice,sPrice;
} M ;
int main(){
    M m;
    float Lai;
    scanf("%d",&m.bQuantity);
    scanf("%f",&m.bPrice);
    scanf(" %d",&m.sQuantity);
    scanf("%f",&m.sPrice);

    Lai=m.sQuantity*m.sPrice-m.bQuantity*m.bPrice;
    printf("%.2f",Lai);
    return 0;
}
