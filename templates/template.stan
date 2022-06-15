data{
	// SIZES
    int<lower=0> N;

	// PRIMARY INPUT/OUTPUT
    array[N] int       P;
    matrix[N,N_A]      A;
    vector[N]          B;
    vector<lower=0>[N] C;
    real<lower=14>     D;
}

parameters{
	// MODEL VARIABLES
	
	// OFF CENTRE
	vector[N_A]     zAbar;
	real<lower=0>   tau_A;
	
	// MULTI LEVEL CENTRED
	array[N_A] vector[N_T] a;  //NOTE: The matrix definition
    vector<lower=0>[N_T] sigma_A;
    corr_matrix[N_T] Rho_A;
    
	// MULTI LEVEL OFF CENTRE
    matrix[N_T,N_A] zA;
    real<lower=0> tau_A;
    vector<lower=0>[N_T] sigma_A;
    cholesky_factor_corr[N_T] L_Rho_A;
    
    // GAUSSIAN CENTRED
    
}

transformed parameters{
	// OFF CENTRE
	abar = zAbar * tau_A;
	
	// MULTI LEVEL OFF CENTRE
    matrix[N_A,N_T] a;
    a = (diag_pre_multiply(sigma_A, L_Rho_A) * zA)'; // (diag(sigma_A) L_A zA)'
}

model{
    vector[N] p;
    
	// OFF CENTRE
	tau_A ~ exponential(1);
	zAbar ~ normal(0, 1); // As opposed to normal(0, tau_A)
	
	// MULTI LEVEL CENTRED
	a ~ multi_normal( rep_vector(0,N_T), quad_form_diag(Rho_A, sigma_A));
	
	// MULTI LEVEL OFF CENTRE
    L_Rho_A ~ lkj_corr_cholesky(N_T);
    sigma_A ~ exponential(1);
	to_vector(zA) ~ normal(0, 1);
    for ( i in 1:N ) {
        p[i] = a[A1[i], A2[i]];
        p[i] = inv_logit(p[i]);
    }
    
    P ~ uniform( lower, upper )
    P ~ normal( mu, sigma )    // halfnormal is just defining P lower=0
    P ~ lognormal( mu, sigma ) // normal( log(mu), sigma )
    P ~ bernoulli( p );        // [0,1] -> 0,1
    n ~ binomial( N, p )       // n successes, N trials, p success 
    N ~ poisson( lambda )      // Peak lambda in N
    P ~ exponential( beta )    // beta halflife
    P ~ beta( p1, p2 )         // P^p1 (1 - P)^p2
    P ~ dirichlet( as )        // len(as) probabilities that add to 1
    P ~ ordered_logistic( eta, c ) //
}

generated quantities{
    vector[N] log_lik; //STAT RETHINKING COMPARE
    vector[N] p;
    
    // MULTI LEVEL OFF CENTRE
    matrix[N_T,N_T] Rho_A;
    Rho_A = multiply_lower_tri_self_transpose(L_Rho_A); // Regenerate centred
    for ( i in 1:N ) {
        p[i] = a[A1[i], A2[i]];
        p[i] = inv_logit(p[i]);
        log_lik[i] = bernoulli_lpmf( P[i] | p[i] );
    }
}