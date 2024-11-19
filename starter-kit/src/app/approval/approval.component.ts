import { Component, OnInit } from '@angular/core';
import { StatisticsService } from 'app/main/sample/services/statistics.service';

@Component({
  selector: 'app-pending-agency-registrations',
  templateUrl: './approval.component.html',
  styleUrls: ['./approval.component.scss']
})
export class ApprovalComponent implements OnInit {
  public pendingAgencies: any[] = [];

  constructor(private statisticsService: StatisticsService) { }

  ngOnInit(): void {
    this.loadPendingAgencies();
  }

  loadPendingAgencies() {
    this.statisticsService.getPendingAgencyRegistrations().subscribe(
      (response: any) => {
        this.pendingAgencies = response.pendingRegistrations;
      },
      (error) => {
        console.error('Error fetching pending agencies:', error);
      }
    );
  }

  approveAgency(id: string) {
    this.statisticsService.approveAgencyRegistration(id).subscribe(
      (response: any) => {
        console.log('Agency approved:', response.message);
        this.loadPendingAgencies(); // Refresh the list
      },
      (error) => {
        console.error('Error approving agency:', error);
      }
    );
  }

  rejectAgency(id: string) {
    this.statisticsService.rejectAgencyRegistration(id).subscribe(
      (response: any) => {
        console.log('Agency rejected:', response.message);
        this.loadPendingAgencies(); // Refresh the list
      },
      (error) => {
        console.error('Error rejecting agency:', error);
      }
    );
  }
}
