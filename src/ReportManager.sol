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
    error ReportDoesNotExist(uint256 reportId);

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

    //librarynya (untuk carik timestamp)
    function getDateKey(uint256 timestamp) internal pure returns (uint256){
        (uint year, uint month, uint day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
        return year * 10000 + month * 100 + day;
    }

    function getCurrentDateKey() external view returns (uint256){
        return getDateKey(block.timestamp);
    }

    // senin = 1, minggu = 7
    function getDayOfWeek(uint256 timestamp) external pure returns (uint){
        return BokkyPooBahsDateTimeLibrary.getDayOfWeek(timestamp);
    }

    function getReport(uint256 reportId) external view returns (DailyReport memory) {
        if(reportId >= reportIdCounter || reportId == 0) {
            revert ReportDoesNotExist(reportId);
            return reports[reportId];
        }
    }

    function getReportByDate(uint256 date) external view returns (DailyReport memory) {
        uint256 reportId = reportsByDate[date];
        if(reportId < 0){
            revert ReportDoesNotExist(date);
        }
        return reports[reportId];
    }

    function getTotalReports() external view returns (uint256) {
        return reportIdCounter - 1;
    }
}
