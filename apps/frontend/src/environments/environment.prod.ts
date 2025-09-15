export const environment = {
  production: true,
  backendUrl:
    (window as any)['env']?.['BACKEND_URL'] ||
    'https://backend-244lwdt5ta-an.a.run.app',
};
