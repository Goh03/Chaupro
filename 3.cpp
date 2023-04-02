#include <stdio.h>
#include<conio.h>
int main(){
    char ch='A';
    int i=1234,j=-1234;
    float x=11.23456789;
    printf("%-5c,%5c\n",ch,ch);
    printf("%d,%-10d,%+10d,%10.6d,%010d\n",i,i,i,i,j);
    printf("%f,%12f,%-12.4f,%+012.4f\n",x,x,x,x);
    printf("%*f\n",12,x);
    printf("%*.*f",12,3,x);
    getch();
    return 0 ;
}