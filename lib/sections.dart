// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _mediumPurple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _mySin = Color(0xFFF3A646);

class SectionDetail {
  const SectionDetail({
    this.title,
    this.subtitle,
    this.imageAsset,
    this.imageAssetPackage,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
  final String imageAssetPackage;
}

class Section {
  const Section({
    this.title,
    this.backgroundAsset,
    this.backgroundAssetPackage,
    this.leftColor,
    this.rightColor,
    this.details,
  });
  final String title;
  final String backgroundAsset;
  final String backgroundAssetPackage;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;

  @override
  bool operator==(Object other) {
    if (other is! Section)
      return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

const SectionDetail _eyeglassesDetail = SectionDetail(
  imageAsset: 'assets/scooter.jpg',
  title: 'E-Scooters are the future of mobility',
  subtitle: '5K views - 2 days',
);

const SectionDetail _eyeglassesImageDetail = SectionDetail(
  imageAsset: 'assets/scooter.jpg',
);

const SectionDetail _seatingDetail = SectionDetail(
  imageAsset: 'assets/luas.jpg',
  title: 'LUAS - low carbon footprint, fast travel',
  subtitle: '9K views - 1 days',
);

const SectionDetail _seatingImageDetail = SectionDetail(
  imageAsset: 'assets/luas.jpg',
);

const SectionDetail _decorationDetail = SectionDetail(
  imageAsset: 'assets/bicycle.jpg',
  title: 'Get fit and skip Dublin traffic',
  subtitle: '5K views - 8 days',
);

const SectionDetail _decorationImageDetail = SectionDetail(
  imageAsset: 'assets/bicycle.jpg',
);

const SectionDetail _protectionDetail = SectionDetail(
  imageAsset: 'assets/motorbike.jpg',
  title: 'Freedom and speed - the way to commute',
  subtitle: '10K views - 3 days',
);

const SectionDetail _protectionImageDetail = SectionDetail(
  imageAsset: 'assets/motorbike.jpg',
);

final List<Section> allSections = <Section>[
  const Section(
    title: 'E-SCOOTERS',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    backgroundAsset: 'assets/scooter.jpg',
    details: <SectionDetail>[
      _eyeglassesDetail,
      _eyeglassesImageDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
    ],
  ),
  const Section(
    title: 'LUAS',
    leftColor: _tomato,
    rightColor: _mediumPurple,
    backgroundAsset: 'assets/luas.jpg',
    details: <SectionDetail>[
      _seatingDetail,
      _seatingImageDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
    ],
  ),
  const Section(
    title: 'BICYCLES',
    leftColor: _mySin,
    rightColor: _tomato,
    backgroundAsset: 'assets/bicycle.jpg',
    details: <SectionDetail>[
      _decorationDetail,
      _decorationImageDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
    ],
  ),
  const Section(
    title: 'MOTORBIKES',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: 'assets/motorbike.jpg',
    details: <SectionDetail>[
      _protectionDetail,
      _protectionImageDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
    ],
  ),
];
