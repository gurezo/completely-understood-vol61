export const environment = {
  production: false,
  backendUrl:
    (window as any)['env']?.['BACKEND_URL'] ||
    'https://backend-244lwdt5ta-an.a.run.app',
};
