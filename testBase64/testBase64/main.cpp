//
//  main.cpp
//  testBase64
//
//  Created by Aron Ruan on 2022/7/22.
//

//#include "cppcodec/base32_crockford.hpp"
#include "cppcodec/base64_rfc4648.hpp"
#include "cppcodec/base64_url.hpp"
#include "cppcodec/base64_default_url.hpp"
//#include "cppcodec/base64_url_unpadded.hpp"
//#include "cppcodec/base64_default_url_unpadded.hpp"
#include <iostream>

#include "cppcodec/base64_url.hpp"

int main() {
//    using base32 = cppcodec::base32_crockford;
    using base64 = cppcodec::base64_rfc4648;

    std::vector<uint8_t> decoded = base64::decode("PGRpdiBkaXI9ImF1dG8i");
    std::cout << "decoded size (\"any carnal pleasure\"): " << decoded.size() << '\n';
    std::cout<<decoded.data()<<std::endl;
//    std::cout << base32::encode(decoded) << std::endl; // "C5Q7J833C5S6WRBC41R6RSB1EDTQ4S8"
//    std::vector<uint8_t> decoded2 = base
    
    using base64_url =cppcodec:: detail::codec<cppcodec::detail::base64<cppcodec::detail::base64_url>>;
    
    std::vector<uint8_t> decoded2 = base64_url::decode("PGRpdiBkaXI9ImF1dG8iPuaIkeaYr-ato-aWhzxiciAvPjxiciAvPjxiciAvPjxiciAvPjxiciAvPjxkaXY-5Y-R6Ieq5oiR55qE6I2j6ICA5omL5py6PC9kaXY-PC9kaXY-");
    std::cout<<decoded2.data()<<std::endl;
    return 0;
}
