Require Export ZArith.
Require Export Znumtheory.
Require Export Zpow_facts.

Definition inf_primes_of_form (f : Z -> Z) :=
  forall l : Z, exists n : Z, l < n /\ prime (f n).
  

(* Theorem 10: x>=2 -> pi(x) >= loglog x *)

(* Theorem 11: Infinitely many primes of form, 4n+3 *)
Theorem theorem_11 : inf_primes_of_form (fun n => 4*n+3).
Proof.
  unfold inf_primes_of_form.
  intros.
Abort.

(* Theorem 12: 6n+5 *)
Theorem theorem_12 : inf_primes_of_form (fun n => 6*n+5).
Proof.
Abort.

(* Theorem 13 *)
Theorem theorem_13 :
  forall a b: Z, rel_prime a b -> 
                 forall p : Z, prime p /\ p<>2 /\ (p|(a*a + b*b)) -> p mod 4 = 1.
Abort.
                                                                      
(* Theorem 14: 8n+5 *)
Theorem theorem_14 : inf_primes_of_form (fun n => 8*n+5).
Abort.

(* Theorem 15: Dirichlet's theorem (not proven in book...) *)
Theorem dirichlets_theorem : forall a b : Z,
    a > 0 /\ (rel_prime a b) -> inf_primes_of_form (fun n => a*n+b).
Proof.
  intros.
Abort.

(* Theorem 16: No two Fermat numbers have a gcd > 1 *)

(* try an inductive definition here? *)
Definition F (n : Z) := 2^2^n + 1.

Lemma div_minus_trans : forall m a b : Z, (m|a) /\ (m|(a+b)) -> (m | b).
Proof.
  intros.
  destruct H.
  destruct H.
  destruct H0.
  rewrite H in H0.

  assert (mdb : x0 * m - x * m = b). omega.
  clear H0 H a.
  rewrite <- Z.mul_sub_distr_r in mdb.

  exists (x0 - x).
  auto.
Qed.

Theorem theorem_16 : forall n k : Z,
    n > 0 /\ k > 0 -> rel_prime (F n) (F (n+k)).
Proof.
  intros n k [ngz kgz].
  constructor; auto with zarith.
  intros m dn dnk.
  
  assert (mn2 : Z.abs m <> 2).
  {
    clear dnk.
    unfold F in dn.
    red.
    intros.
    apply Zdivide_Zabs_inv_l in dn.
    rewrite H in dn.
    clear H m k kgz.
  
    destruct dn.
    assert (Zodd (2 ^ 2 ^ n + 1)).
    replace (2 ^ n) with ((2 ^ n) - 1 + 1); [|ring].
    rewrite Zpower_exp.
    rewrite Zodd_ex_iff.
    exists (2 ^ (2 ^ n - 1)).
    rewrite Z.pow_1_r.
    rewrite Z.mul_comm.
    reflexivity.
    
    (* stupid proof of 2 ^ n - 1 >= 0 *)
    apply Z.ge_le_iff.
    apply Z.lt_le_pred.
    apply Z.pow_pos_nonneg; omega.
    omega.

    rewrite H in H0.
    apply Zodd_not_Zeven in H0.
    apply H0.
    
    apply Zeven_ex_iff.
    exists x.
    ring.
  }
  
  assert ((F n)|((F (n+k))-2)).
  {
    clear dn dnk mn2 m.
    unfold F.
    rewrite Z.pow_add_r; try omega.
    rewrite Z.pow_mul_r; auto with zarith.
    pose (x := 2 ^ 2 ^ n).
    fold x.

    pose (mk := k-1).
    assert (k = mk+1). omega.
    rewrite H.

    replace (x ^ 2 ^ (mk + 1) + 1 - 2) with (x ^ 2 ^ (mk + 1) - 1); [|ring].

    pattern mk.
    apply natlike_ind.
    simpl.
    exists (x-1).
    replace (Z.pow_pos x 2) with (x*x).
    ring.
    unfold Z.pow_pos.
    unfold Pos.iter.
    ring.
    
    intros.
    replace (Z.succ x0 + 1) with (Z.succ (x0 + 1)); [|ring].
    rewrite Z.pow_succ_r.

    pose (t := 2 ^ (x0 + 1)).
    fold t in H1.
    fold t.

    destruct H1.
    exists (x1*(x^t+1)).
    replace (2*t) with (t+t); [|ring].
    rewrite Zpower_exp; unfold t; try apply Z.ge_le_iff; auto with zarith.
    fold t.
    
    rewrite <- Z.mul_assoc.
    rewrite (Z.mul_comm (x ^ t + 1) (x + 1)).
    rewrite -> Z.mul_assoc.
    rewrite <- H1.
    ring.
    omega.
    omega.
  }

  specialize (Z.divide_trans m (F n) (F (n + k) - 2)).
  intros.
  apply H0 in H; [|assumption].
  clear H0 dn.

  specialize (div_minus_trans m (F (n + k)) (-2)).
  intros.
  destruct H0.
  split; auto.
  clear H dnk.

  assert (m|(-2)).
  exists x.
  apply H0.
  apply Zdivide_opp_r in H.
  simpl in H.
  
  specialize (prime_divisors 2 prime_2 m).
  intros. apply H1 in H. clear H1.

  destruct H. rewrite H. auto with zarith.
  destruct H. rewrite H. auto with zarith.
  destruct H; (rewrite H in mn2; simpl in mn2; contradiction).
Qed.


(* Theorem 17 *)
Theorem theorem_17 :
  forall a n : Z, a >= 2 /\ prime (a^n + 1) -> Zeven a /\ exists m : Z, n = 2^m.
Proof.
Abort.

(* Theorem 18 *)
Lemma div_am1_anm1 : forall a n : Z, n >= 0 -> ((a - 1) | (a^n - 1)).
Proof.
  intros a n ng0.

  pattern n.
  apply natlike_ind; [exists 0; reflexivity| |omega].

  intros.
  destruct H0.
  
  rewrite Z.pow_succ_r; [|assumption].
  
  exists (x0*a + 1).
  symmetry.
  rewrite -> Z.mul_add_distr_r.
  rewrite <- Z.mul_assoc.
  rewrite (Z.mul_comm a (a-1)).
  rewrite -> Z.mul_assoc.
  rewrite <- H0.
  ring.
Qed.

Search (_ <= _ -> _ >= _).

Lemma div2k : forall n k : Z, k>0 /\ n>0 /\ (k|n) -> ((2 ^ k - 1) | (2 ^ n - 1)).
Proof.
  intros n k [knz [nnz H]].
  destruct H.
  rewrite H.

  pattern x.
  apply natlike_ind.
  exists 0.
  rewrite Zmult_0_l.
  simpl.
  reflexivity.

  intros.
  replace (Z.succ x0 * k) with (x0 * k + k); [|ring].
  destruct H1.
  assert (2 ^ (x0 * k) = x1 * (2 ^ k - 1) + 1).
  rewrite <- H1.
  ring.

  rewrite Zpower_exp.
  rewrite H2.
  rewrite Z.mul_add_distr_r.
  rewrite Z.mul_1_l.
  rewrite Z.mul_sub_distr_l.
  rewrite Z.mul_sub_distr_r.

  exists ((x1 * 2 ^ k + 1)).
  ring.
  
  apply Z.le_ge.
  apply Z.mul_nonneg_nonneg.
  assumption.
  omega.
  omega.

  rewrite H in nnz.
  apply Z.gt_lt in nnz.
  apply Z.mul_pos_cancel_r in nnz.
  omega.
  omega.
Qed.
  
Lemma prime_2nm1_prime_n : forall n : Z, prime (2^n - 1) -> prime n.
Proof.
  intros.

  assert (nn1 : n <> 1).
  red. intros. rewrite H0 in H. simpl in H. apply not_prime_1 in H. apply H.

  assert (nn0 : n <> 0).
  red. intros. rewrite H0 in H. simpl in H. apply not_prime_0 in H. apply H.
  
  assert (~(n < 0)).
  {
    apply prime_ge_2 in H.
    apply Z.le_le_succ_r in H.
    replace (Z.succ (2 ^ n - 1)) with (2 ^ n) in H; [|omega].
    red.
    intros.
    specialize (Z.pow_neg_r 2 n).
    intros eq.
    apply eq in H0.
    rewrite H0 in H.
    simpl.
    omega.
  }
  
  case (prime_dec n); auto.
  intros.
  specialize (not_prime_divide n).
  intros eq. destruct eq.
  omega.
  assumption.
  destruct H1.

  apply prime_alt in H.
  unfold prime' in H.
  destruct H.
  specialize (H3 (2^x - 1)).

  destruct H3.
  split.
  replace 1 with (2^1-1); [|reflexivity].
  apply Z.sub_lt_mono_r.
  apply Zpower_lt_monotone.
  omega.
  omega.
  apply Z.sub_lt_mono_r.
  apply Zpower_lt_monotone.
  omega.
  omega.
  
  apply div2k.
  split. omega.
  split. omega.
  apply H2.
Qed.

      
Theorem theorem_18 :
  forall a n : Z, a > 0 /\ n > 1 /\ prime (a^n - 1) -> a = 2 /\ prime n.
Proof.
  intros a n [agt0 [ngt1 pan]].
  
  assert (ai2 : a = 2).

  assert (~(a > 2)).
  intros agt2.

  induction pan.
  specialize (H0 (a - 1)).
  destruct H0.

  split.
  omega.

  rewrite <- Z.sub_lt_mono_r.
  rewrite <- (Z.pow_1_r a) at 1.
  apply Zpower_lt_monotone; try omega.

  specialize (H2 (a - 1)).
  destruct H2.
  exists 1; omega.
  apply div_am1_anm1.
  omega.

  specialize (Z.eq_mul_1_nonneg (a-1) x).
  intros die.
  destruct die; try omega.

  rewrite Z.mul_comm.
  rewrite <- H2.
  reflexivity.

  assert (a <> 1).
  {
    intros eq.
    rewrite eq in pan.
    rewrite Z.pow_1_l in pan.
    simpl in pan.
    apply not_prime_0 in pan.
    apply pan.
    omega.
  }

  omega.
  split.
  assumption.

  rewrite ai2 in pan.
  clear ai2 agt0 a.

  apply prime_2nm1_prime_n.
  assumption.
Qed.

(* Theorem 19: prime series is divergent *)

(* Theorem 20: stuff about pi(x) *)

(* Theorem 21: no polynomial is prime for all n *)

(* Theorem 22: all polynomials have infinite composites *)

(* Theorem 23 *)

(* Theorem 24 *)

(* Theorem 25 *)

(* Theorem 26 *)

(* Theorem 27 *)


