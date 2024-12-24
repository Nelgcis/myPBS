/**
 * \file
 * \brief Float3AffineTransform class implementation
 */
#include "float3_affine_transform.cuh"
#include "helper_math.h"
#include "helper_float3.cuh"
#include <iostream>

Float3AffineTransform::Float3AffineTransform() : m(1.0f, 1.0f, 1.0f), v(make_float3(0.0f, 0.0f, 0.0f)) {}

Float3AffineTransform::Float3AffineTransform(const Matrix3x3 mIn, const float3 vIn) : m(mIn), v(vIn) {}

Float3AffineTransform::Float3AffineTransform(const Float3AffineTransform& in) : Float3AffineTransform(in.getMatrix(),in.getOffset()) {}

CUDA_CALLABLE_MEMBER float3 Float3AffineTransform::transformPoint(const float3 point) const {return m*point + v;}

CUDA_CALLABLE_MEMBER float3 Float3AffineTransform::transformVector(const float3 vector) const {return m*vector;}

Float3AffineTransform Float3AffineTransform::inverse() const
{
    return Float3AffineTransform(m.inverse(), m.inverse()*(v*(-1)));
}

void Float3AffineTransform::oneBasedToZeroBased(const bool toIdx)
{
    if (toIdx) v -= make_float3(1.0f, 1.0f, 1.0f);
    else v += make_float3(sum_float3(m.row0()), sum_float3(m.row1()), sum_float3(m.row2()));
}

CUDA_CALLABLE_MEMBER Matrix3x3 Float3AffineTransform::getMatrix() const {return m;}

CUDA_CALLABLE_MEMBER float3 Float3AffineTransform::getOffset() const {return v;}

void Float3AffineTransform::print() const
{
    printf("%f %f %f    %f\n", m.row0().x, m.row0().y, m.row0().z, v.x);
    printf("%f %f %f    %f\n", m.row1().x, m.row1().y, m.row1().z, v.y);
    printf("%f %f %f    %f\n", m.row2().x, m.row2().y, m.row2().z, v.z);
}

Float3AffineTransform concatFloat3AffineTransform(const Float3AffineTransform t1, const Float3AffineTransform t2)
{
    return(Float3AffineTransform(t2.m*t1.m, t2.m*t1.v+t2.v));
}

