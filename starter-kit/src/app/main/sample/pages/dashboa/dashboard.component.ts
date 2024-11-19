/* starter-kit\src\app\main\sample\pages\dashboa\dashboard.component.ts */
import { Component, OnInit } from '@angular/core';
import { StatisticsService } from '../../services/statistics.service';

@Component({
  selector: 'app-home',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  public contentHeader: object;
  public guestCount: number = 0;
  public userCount: number = 0;
  public agencyCount: number = 0;

  constructor(private statisticsService: StatisticsService) {}

  ngOnInit() {
    this.contentHeader = {
      headerTitle: 'Home',
      actionButton: true,
      breadcrumb: {
        type: '',
        links: [
          {
            name: 'Home',
            isLink: true,
            link: '/'
          },
          {
            name: 'Sample',
            isLink: false
          }
        ]
      }
    };

    this.loadStatistics();
  }

  loadStatistics() {
    this.statisticsService.getGuestCount().subscribe(
      (response: any) => {
        console.log('Guest Count:', response);
        this.guestCount = response.count;
      },
      (error) => {
        console.error('Error fetching guest count:', error);
      }
    );

    this.statisticsService.getUserCount().subscribe(
      (response: any) => {
        console.log('User Count:', response);
        this.userCount = response.userCount;
      },
      (error) => {
        console.error('Error fetching user count:', error);
      }
    );

    this.statisticsService.getAgencyCount().subscribe(
      (response: any) => {
        console.log('Agency Count:', response);
        this.agencyCount = response.agencyCount;
      },
      (error) => {
        console.error('Error fetching agency count:', error);
      }
    );
  }
}
