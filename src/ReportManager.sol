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
    error ZeroAddress(address falseAddress);

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
    ) external {
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
    function getDateKey(uint256 timestamp) internal pure returns (uint256) {
        (uint256 year, uint256 month, uint256 day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
        return year * 10000 + month * 100 + day;
    }

    function getCurrentDateKey() external view returns (uint256) {
        return getDateKey(block.timestamp);
    }

    // senin = 1, minggu = 7
    function getDayOfWeek(uint256 timestamp) external pure returns (uint256) {
        return BokkyPooBahsDateTimeLibrary.getDayOfWeek(timestamp);
    }

    function getReport(uint256 reportId) external view returns (DailyReport memory) {
        if (reportId >= reportIdCounter || reportId == 0) {
            revert ReportDoesNotExist(reportId);
        }
        return reports[reportId];
    }

    function getReportByDate(uint256 date) external view returns (DailyReport memory) {
        uint256 reportId = reportsByDate[date];
        if (reportId < 0) {
            revert ReportDoesNotExist(date);
        }
        return reports[reportId];
    }

    function getTotalReports() external view returns (uint256) {
        return reportIdCounter - 1;
    }

    // report batch
    function getReportsBatch(uint256 startId, uint256 count) external view returns (DailyReport[] memory) {
        require(startId > 0 && startId < reportIdCounter, "Invalid start Id");

        uint256 endId = startId + count;
        if (endId >= reportIdCounter) {
            endId = reportIdCounter;
        }

        uint256 batchSize = endId - startId;
        DailyReport[] memory batch = new DailyReport[](batchSize);

        for (uint256 i = 0; i < batchSize; i++) {
            batch[i] = reports[startId + i];
        }

        return batch;
    }

    function getReportsByIds(uint256[] calldata reportIds) external view returns (DailyReport[] memory) {
        require(reportIds.length > 0, "Empty array");

        DailyReport[] memory result = new DailyReport[](reportIds.length);

        for (uint256 i = 0; i < reportIds.length; i++) {
            require(reportIds[i] > 0 && reportIds[i] < reportIdCounter, "Invalid report ID");
            result[i] = reports[reportIds[i]];
        }

        return result;
    }

    function getWeatherData(uint256 reportId) external view returns (WeatherData memory) {
        if (reportId >= reportIdCounter || reportId == 0) {
            revert ReportDoesNotExist(reportId);
        }
        return reports[reportId].weather;
    }

    function getCareActions(uint256 reportId) external view returns (CareActions memory) {
        if (reportId >= reportIdCounter || reportId == 0) {
            revert ReportDoesNotExist(reportId);
        }
        return reports[reportId].actions;
    }

    function getHealthStatus(uint256 reportId) external view returns (HealthStatus memory) {
        if (reportId >= reportIdCounter || reportId == 0) {
            revert ReportDoesNotExist(reportId);
        }
        return reports[reportId].health;
    }

    //untuk transfer ownership baru
    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) {
            revert ZeroAddress(newOwner);
        }
        address oldOwner = owner;
        owner = newOwner;
        emit ownershipTransferrred(oldOwner, newOwner);
    }
}
