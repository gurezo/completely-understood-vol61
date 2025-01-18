import { HttpClient } from '@angular/common/http';
import { Component, inject, ViewEncapsulation } from '@angular/core';

@Component({
  selector: 'app-nx-welcome',
  imports: [],
  template: ``,
  styles: [],
  encapsulation: ViewEncapsulation.None,
})
export class NxWelcomeComponent {
  private http = inject(HttpClient);

  inputValue: number | null = null;
  result: number | null = null;
}
