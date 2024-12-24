/**
 * \file
 * \brief CUDA error assert function implementations
 */
#include "cuda_errchk.cuh"
#include "cuda_runtime_api.h"

#include <sstream>
#include <sstream>
#include <stdexcept>

void cudaAssert(const cudaError_t code, const char* file, const int line, const bool abort)
{
    if (code != cudaSuccess)
    {
        //fprintf(stderr,"cudaAssert: %s %s %d\n", cudaGetErrorString(code), file, line);
        //if (abort) exit(code);
        std::ostringstream msgStream;
        msgStream << "cudaAssert: " << cudaGetErrorString(code) << " " << file << ", line: " <<  line;
        throw std::runtime_error(msgStream.str());
    }
}
