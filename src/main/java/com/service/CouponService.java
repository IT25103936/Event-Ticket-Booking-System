package com.service;

import com.model.Coupon;

import java.io.File;
import java.util.List;

public interface CouponService {

    List<Coupon> readFile(File file);

    void create(File file, Coupon coupon);

    void update(File file, Coupon coupon);

    void delete(File file, int id);

    void writeFile(File file, List<Coupon> coupons);
}