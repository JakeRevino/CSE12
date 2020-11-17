/**
 * @file Lab3.cpp
 * @author Jake Revino (jrevino@ucsc.edu)
 * @brief This is a C++ program I wrote to help better understand the MIPS code
 * @version 0.1
 * @date 2020-11-15
 * 
 * @copyright Copyright (c) 2020
 * 
 */


#include <iostream>
 
//using namespace std;

int main() {
int height;

    std::cout << "Enter a height (greater than 0): ";
    std::cin >> height;
    while (height < 1) {
       std::cerr << "Invalid entry, must be greater than 0. \n";
       std::cout << "Enter a height (greater than 0): ";
    std::cin >> height;
    }
    int tabs = 1;
    int i = 1;
    
    for (int rows = 1, stars = 1; rows <= height; ++rows, stars = 1) {
       int the_row = rows;
      
       
          for (tabs = 1; tabs <= height - the_row; ++tabs) {
            
             std::cout << '\t';
             
             
          }
          if (the_row == 1) {
             std::cout << i << '\n';
            ++the_row;
            
          }
          else {
             ++the_row;
             std::cout << ++i;
            while (stars <= 2*rows - 3) {
               std::cout << '\t' << "*";
               ++stars;
            }
           
               std::cout << '\t' << ++i << std::endl;
         } 
    }
    std::cout << '\n';
}