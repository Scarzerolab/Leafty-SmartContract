// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReportManager {
    enum WeatherCondition {
        SUNNY,
        CLOUDY,
        RAINY,
        STORMY,
        WINDY,
        OTHER
    }

    enum SoilCondition {
        DRY,
        MOIST,
        WET,
        WATERLOGGED,
        CRAKED
    }

    enum DiseaseType {
        NONE,
        LEAF_SPOTS,
        POWDERY_GROWTH,
        WILTING,
        OTHER
    }

    // struktur datan
    struct DailyReport {
        uint256 id;
        uint256 timestamp;
        int16 temperature;
        WeatherCondition weather;
        bool wateredtoday;
        SoilCondition soilCondition;
        bool compostAdded;
        string compostType; // kalau gaada tinggal empty string
        bool fertilizerAdded;
        string fertilizerType;
        DiseaseType diseaseType;
        string diseaseOtherDescription; //untuk other
        string extraNotes;
        address submittedBy;
    }

    //mapping untuk id
    mapping(uint256 => DailyReport) public reports;
    uint256 public reportIdCounter;
    address public owner;

    //mapping pakek timestamp
    mapping(uint256 => uint256) public reportsByDate;
    uint256[] public allReportsIds;
}
