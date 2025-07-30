// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "BokkyPooBahsDateTimeLibrary/BokkyPooBahsDateTimeLibrary.sol";

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

    struct WeatherData {
        int16 temperature;
        WeatherCondition condition;
    }

    struct CareActions {
        bool waterToday;
        bool compostAdded;
        string compostType;
        bool fertilizerAdded;
        string fertilizerType;
    }

    struct HealthStatus {
        DiseaseType diseaseType;
        string diseaseOtherDescription; //untuk other
        SoilCondition soilCondition;
    }

    // struktur data
    struct DailyReport {
        uint256 id;
        uint256 timestamp;
        WeatherData weather;
        CareActions actions;
        HealthStatus health;
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

    //tempat events
    event ReportSubmitted(
        uint256 indexed reportid, uint256 indexed date, address indexed submitter, int16 temperature, bool wateredToday
    );
    event ownershipTransferrred(address indexed previousOwner, address indexed newOwner);

    //error
    error Unauthorized(address signer);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Unauthorized(msg.sender);
        }
        _;
    }

    constructor() {
        owner = msg.sender;
        reportIdCounter = 1;
    }

    //funtion-functionnya
    function submitDailyReport(
        WeatherData memory _weather,
        CareActions memory _actions,
        HealthStatus memory _health,
        string memory _extraNotes
    ) external onlyOwner {
        uint256 currentReportId = reportIdCounter;
        uint256 currentTimestamp = block.timestamp;

        reports[currentReportId] = DailyReport({
            id: currentReportId,
            timestamp: currentTimestamp,
            weather: _weather,
            actions: _actions,
            health: _health,
            extraNotes: _extraNotes,
            submittedBy: msg.sender
        });

        uint256 datekey = getDateKey(currentTimestamp);
        reportsByDate[currentReportId] = currentReportId;

        //array nya
        allReportsIds.push(currentReportId);

        emit ReportSubmitted(currentReportId, datekey, msg.sender, _weather.temperature, _actions.waterToday);

        reportIdCounter++;
    }
}
