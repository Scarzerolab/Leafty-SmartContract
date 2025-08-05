// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "src/ReportManager.sol";

contract ReportManagerTest is Test {
    ReportManager public mainContract;
    address public owner;
    address public nonOwner;

    ReportManager.WeatherData public testWeather;
    ReportManager.CareActions public testActions;
    ReportManager.HealthStatus public testHealth;
    string public testNotes;

    function setUp() public {
        owner = address(this);
        nonOwner = address(0x18586E5F492273F2ba004Cbc7FcB68f8bA9d4aa2);

        //deploy
        mainContract = new ReportManager();

        testWeather = ReportManager.WeatherData({
            temperature: 255,
            condition: ReportManager.WeatherCondition.SUNNY
        });

        testActions = ReportManager.CareActions({
            waterToday: true,
            compostAdded: true,
            compostType: "compost organik",
            fertilizerAdded: false,
            fertilizerType: ""
        });

        testHealth = ReportManager.HealthStatus({
            diseaseType: ReportManager.DiseaseType.NONE,
            diseaseOtherDescription: "",
            soilCondition: ReportManager.SoilCondition.MOIST
        });

        testNotes = "kelornya sehat-sehat";
    }

    function testSubmitDailyReport() public {
        assertEq(mainContract.reportIdCounter(), 1);
    }
}