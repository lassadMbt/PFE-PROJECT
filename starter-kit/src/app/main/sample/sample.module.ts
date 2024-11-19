import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { TranslateModule } from '@ngx-translate/core';

import { CoreCommonModule } from '@core/common.module';

import { ContentHeaderModule } from 'app/layout/components/content-header/content-header.module';

import { SampleComponent } from './sample.component';
import { HomeComponent } from './home.component';
import { DashboardComponent } from './pages/dashboa/dashboard.component';
import { UserManagementComponent } from 'app/user-management/user-management.component';
import { AgencyManagementComponent } from 'app/agency-management/agency-management.component';
import { AuthGuard } from 'app/auth/helpers';

const routes = [
  {
    path: 'sample',
    component: SampleComponent,
    canActivate:[AuthGuard],

    data: { animation: 'sample' }
  },
  {
    path: 'home',
    component: HomeComponent,
    canActivate:[AuthGuard],

    data: { animation: 'home' }
  },
  {
    path: 'dashboard',
    component: DashboardComponent,
    canActivate:[AuthGuard],

    data: { animation: 'home' }
  },
  {
    path: 'UserManagement',
    component: UserManagementComponent,
    canActivate:[AuthGuard],

    data: { animation: 'home' }
  },
  {
    path: 'AgencyManagement',
    component: AgencyManagementComponent,
    canActivate:[AuthGuard],
    data: { animation: 'home' },
    
  },
];

@NgModule({
  declarations: [SampleComponent, HomeComponent,DashboardComponent],
  imports: [RouterModule.forChild(routes), ContentHeaderModule, TranslateModule, CoreCommonModule],
  exports: [SampleComponent, HomeComponent]
})
export class SampleModule {}
