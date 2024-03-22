#include <iostream>
#include <unistd.h>
#include <string>
#include <fstream>
// #include <iomanip>
// #include <sstream>
// #include <filesystem>

int main(int argc, char *argv[])
{
    std::string input_path, output_path;
    int o;
    const char *optstring = "s:o:";
    while ((o = getopt(argc, argv, optstring)) != -1)
    {
        switch (o)
        {
            case 's':
                input_path = optarg;
                printf("opt is a, oprarg is: %s\n", optarg);
                break;
            case 'o':
                output_path = optarg;
                printf("opt is b, oprarg is: %s\n", optarg);
                break;
            case '?':
                printf("error optopt: %c\n", optopt);
                printf("error opterr: %d\n", opterr);
                return 0;
        }
    }

    // std::filesystem::path in_path(input_path);
    // std::filesystem::path out_path(output_path);
    std::ifstream in(input_path, std::ios::in);
    std::ofstream out(output_path, std::ios::out);
    // std::fstream foi("...", std::ios::in|std::ios::out);

    static const char* const lut = "0123456789ABCDEF";

    std::string line;
    int i = 0;
    while (std::getline(in, line))
    {
        if(line.front() == '.' || line.front() == '*')
        {
            if(!i) out << "\"";
            uint8_t tmp = 0x00;
            for(int j = 0; j < 8; ++j)
            {
                if(line[j] == '*')
                {
                    tmp |= (1 << (7 - j));
                }
            }
            // std::stringstream ss;
            out << "0x";
            std::string ss;
            ss.push_back(lut[tmp >> 4]);
            ss.push_back(lut[tmp & 15]);
            out << ss;
            if(++i == 16)
            {
                i = 0;
                out << "\"";
                out << std::endl;
            }
            else
            {
                out << ", ";
            }
        }
    }
    in.close();
    out.close();
    return 0;
}
