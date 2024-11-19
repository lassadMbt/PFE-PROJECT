import { Component, OnInit } from '@angular/core';
import { StatisticsService } from 'app/main/sample/services/statistics.service';

@Component({
  selector: 'app-agency-management',
  templateUrl: './agency-management.component.html',
  styleUrls: ['./agency-management.component.scss']
})
export class AgencyManagementComponent implements OnInit {
  public agencies: any[] = [];
  public filteredAgencies: any[] = [];
  public searchAgency: string = '';

  constructor(private statisticsService: StatisticsService) { }

  ngOnInit(): void {
    this.loadAgencies();
  }

  loadAgencies() {
    this.statisticsService.getAgencies().subscribe(
      (response: any) => {
        this.agencies = response.agencies; // Adjust according to your backend response structure
        this.filteredAgencies = this.agencies;
      },
      (error) => {
        console.error('Error fetching agencies:', error);
      }
    );
  }

  filterAgencies() {
    this.filteredAgencies = this.agencies.filter(agency =>
      agency.agencyName.toLowerCase().includes(this.searchAgency.toLowerCase()) ||
      agency.email.toLowerCase().includes(this.searchAgency.toLowerCase()) ||
      agency.phoneNumber.toLowerCase().includes(this.searchAgency.toLowerCase()) ||
      agency.location.toLowerCase().includes(this.searchAgency.toLowerCase())
    );
  }

  deleteAgency(agency) {
    if (confirm(`Are you sure you want to delete the agency ${agency.agencyName}?`)) {
      this.statisticsService.deleteAgency(agency._id).subscribe(
        () => {
          this.loadAgencies(); // Reload the agencies after deletion
        },
        (error) => {
          console.error('Error deleting agency:', error);
        }
      );
    }
  }
}
