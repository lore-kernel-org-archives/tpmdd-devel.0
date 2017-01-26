From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm2-space: add handling for global
 session exhaustion
Date: Thu, 26 Jan 2017 14:56:15 +0200
Message-ID: <20170126125615.dt5hnfbpmtxk7xlq@intel.com>
References: <1485236113.2534.69.camel@HansenPartnership.com>
	<1485236313.2534.73.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485236313.2534.73.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 09:38:33PM -0800, James Bottomley wrote:
> In a TPM2, sessions can be globally exhausted once there are
> TPM_PT_ACTIVE_SESSION_MAX of them (even if they're all context saved).
> The Strategy for handling this is to keep a global count of all the
> sessions along with their creation time.  Then if we see the TPM run
> out of sessions (via the TPM_RC_SESSION_HANDLES) we first wait for one
> to become free, but if it doesn't, we forcibly evict an existing one.
> The eviction strategy waits until the current command is repeated to
> evict the session which should guarantee there is an available slot.
> 
> On the force eviction case, we make sure that the victim session is at
> least SESSION_TIMEOUT old (currently 2 seconds).  The wait queue for
> session slots is a FIFO one, ensuring that once we run out of
> sessions, everyone will get a session in a bounded time and once they
> get one, they'll have SESSION_TIMEOUT to use it before it may be
> subject to eviction.
> 
> Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

This is not a proper review yet. Just quick question: why do you need
a real time (i.e. created)? Maybe in the force eviction case it would
be enough to sleep lets say 500 ms and pick the victim with smallest
number? I.e. just have increasing u64 counter instead of real time.

That would simplify this patch a lot and does not prevent to refine
later on if workloads show need for more complex logic.

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c   |   1 +
>  drivers/char/tpm/tpm.h        |  39 +++++++-
>  drivers/char/tpm/tpm2-cmd.c   |  15 +++
>  drivers/char/tpm/tpm2-space.c | 213 +++++++++++++++++++++++++++++++++++++++---
>  drivers/char/tpm/tpms-dev.c   |  17 +++-
>  5 files changed, 271 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 6282ad0..150c6b8 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -164,6 +164,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  
>  	mutex_init(&chip->tpm_mutex);
>  	init_rwsem(&chip->ops_sem);
> +	init_waitqueue_head(&chip->session_wait);
>  
>  	chip->ops = ops;
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index b77fc60..9fd6101 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -95,7 +95,8 @@ enum tpm2_return_codes {
>  	TPM2_RC_HANDLE		= 0x008B,
>  	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
>  	TPM2_RC_DISABLED	= 0x0120,
> -	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
> +	TPM2_RC_SESSION_HANDLES	= 0x0905, /* RC_WARN */
> +	TPM2_RC_TESTING		= 0x090A,
>  	TPM2_RC_REFERENCE_H0	= 0x0910,
>  };
>  
> @@ -137,7 +138,8 @@ enum tpm2_capabilities {
>  };
>  
>  enum tpm2_properties {
> -	TPM_PT_TOTAL_COMMANDS	= 0x0129,
> +	TPM_PT_TOTAL_COMMANDS		= 0x0129,
> +	TPM_PT_ACTIVE_SESSIONS_MAX	= 0x0111,
>  };
>  
>  enum tpm2_startup_types {
> @@ -161,8 +163,24 @@ struct tpm_space {
>  	u8 *context_buf;
>  	u32 session_tbl[6];
>  	u8 *session_buf;
> +	u32 reserved_handle;
>  };
>  
> +#define TPM2_HANDLE_FORCE_EVICT 0xFFFFFFFF
> +
> +static inline void tpm2_session_force_evict(struct tpm_space *space)
> +{
> +	/* if reserved handle is not empty, we already have a
> +	 * session for eviction, so no need to force one
> +	 */
> +	if (space->reserved_handle == 0)
> +		space->reserved_handle = TPM2_HANDLE_FORCE_EVICT;
> +}
> +static inline bool tpm2_is_session_force_evict(struct tpm_space *space)
> +{
> +	return space->reserved_handle == TPM2_HANDLE_FORCE_EVICT;
> +}
> +
>  enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
>  	TPM_CHIP_FLAG_IRQ		= BIT(2),
> @@ -175,6 +193,12 @@ struct tpm_chip_seqops {
>  	const struct seq_operations *seqops;
>  };
>  
> +struct tpm_sessions {
> +	struct tpm_space *space;
> +	u32 handle;
> +	unsigned long created;
> +};
> +
>  struct tpm_chip {
>  	struct device dev;
>  	struct device devs;
> @@ -217,8 +241,12 @@ struct tpm_chip {
>  #endif /* CONFIG_ACPI */
>  
>  	struct tpm_space work_space;
> +	struct tpm_space *space;
>  	u32 nr_commands;
>  	u32 *cc_attrs_tbl;
> +	struct tpm_sessions *sessions;
> +	int max_sessions;
> +	wait_queue_head_t session_wait;
>  };
>  
>  #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
> @@ -571,6 +599,13 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
>  int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
>  void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
>  			    unsigned int flags);
> +static inline void tpm2_session_clear_reserved(struct tpm_chip *chip,
> +					       struct tpm_space *space)
> +{
> +	if (space->reserved_handle && !tpm2_is_session_force_evict(space))
> +		tpm2_flush_context_cmd(chip, space->reserved_handle, 0);
> +	space->reserved_handle = 0;
> +}
>  int tpm2_seal_trusted(struct tpm_chip *chip,
>  		      struct trusted_key_payload *payload,
>  		      struct trusted_key_options *options);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 0178816..3a54479 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -1000,6 +1000,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  	struct tpm_buf buf;
>  	u32 nr_commands;
>  	u32 *attrs;
> +	u32 nr_sessions;
>  	int rc;
>  	int i;
>  
> @@ -1075,6 +1076,20 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  
>  	tpm_buf_destroy(&buf);
>  
> +	rc = tpm2_get_tpm_pt(chip, TPM_PT_ACTIVE_SESSIONS_MAX,
> +			     &nr_sessions, NULL);
> +	if (rc)
> +		goto out;
> +
> +	if (nr_sessions > 256)
> +		nr_sessions = 256;
> +
> +	chip->max_sessions = nr_sessions;
> +	chip->sessions = devm_kzalloc(&chip->dev,
> +				      nr_sessions * sizeof(*chip->sessions),
> +				      GFP_KERNEL);
> +	if (!chip->sessions)
> +		rc = -ENOMEM;
>  out:
>  	if (rc > 0)
>  		rc = -ENODEV;
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index ba4310a..7304280 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -32,6 +32,166 @@ struct tpm2_context {
>  	__be16 blob_size;
>  } __packed;
>  
> +static struct tpm_sessions *tpm2_session_chip_get(struct tpm_chip *chip)
> +{
> +	int i;
> +
> +	for (i = 0; i < chip->max_sessions; i++)
> +		if (chip->sessions[i].space == NULL)
> +			return &chip->sessions[i];
> +
> +	return NULL;
> +}
> +
> +static struct tpm_sessions *tpm2_session_chip_find_oldest(struct tpm_chip *chip)
> +{
> +	struct tpm_sessions *sess = NULL;
> +	int i;
> +
> +	for (i = 0; i < chip->max_sessions; i++) {
> +		if (chip->sessions[i].space == NULL)
> +			continue;
> +
> +		if (!sess || time_after(sess->created,
> +					chip->sessions[i].created))
> +			sess = &chip->sessions[i];
> +	}
> +
> +	return sess;
> +}
> +
> +static void tpm2_session_chip_add(struct tpm_chip *chip,
> +				  struct tpm_space *space, u32 h)
> +{
> +	struct tpm_sessions *sess = tpm2_session_chip_get(chip);
> +
> +	sess->space = space;
> +	sess->handle = h;
> +	sess->created = jiffies;
> +}
> +
> +static void tpm2_session_chip_remove(struct tpm_chip *chip, u32 h)
> +{
> +	int i;
> +
> +	for (i = 0; i < chip->max_sessions; i++)
> +		if (chip->sessions[i].handle == h)
> +			break;
> +	if (i == chip->max_sessions) {
> +		dev_warn(&chip->dev, "Missing session %08x", h);
> +		return;
> +	}
> +
> +	memset(&chip->sessions[i], 0, sizeof(chip->sessions[i]));
> +	wake_up(&chip->session_wait);
> +}
> +
> +static int tpm2_session_forget(struct tpm_chip *chip, struct tpm_space *space,
> +			       u32 handle)
> +{
> +	int i, j;
> +	struct tpm2_context *ctx;
> +
> +	for (i = 0, j = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		if (space->session_tbl[i] == 0)
> +			continue;
> +
> +		ctx = (struct tpm2_context *)&space->session_buf[j];
> +		j += sizeof(*ctx) + get_unaligned_be16(&ctx->blob_size);
> +
> +		if (space->session_tbl[i] != handle)
> +			continue;
> +
> +		/* forget the session context */
> +		memcpy(ctx, &space->session_buf[j], PAGE_SIZE - j);
> +		space->session_tbl[i] = 0;
> +		break;
> +	}
> +	if (i == ARRAY_SIZE(space->session_tbl))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int tpm2_session_wait(struct tpm_chip *chip, struct tpm_space *space)
> +{
> +	int rc, failed;
> +	struct tpm_sessions *sess;
> +	const unsigned long min_timeout = msecs_to_jiffies(2000);
> +	unsigned long timeout = min_timeout;
> +	DEFINE_WAIT(wait);
> +
> +	for (failed = 0; ; ) {
> +		prepare_to_wait(&chip->session_wait, &wait, TASK_INTERRUPTIBLE);
> +
> +		mutex_unlock(&chip->tpm_mutex);
> +		rc = schedule_timeout_interruptible(timeout);
> +		mutex_lock(&chip->tpm_mutex);
> +
> +		finish_wait(&chip->session_wait, &wait);
> +
> +		if (signal_pending(current))
> +			/* got interrupted */
> +			return -EINTR;
> +
> +		if (rc > 0 && !tpm2_is_session_force_evict(space))
> +			/* got woken, so slot is free.  We don't
> +			 * reserve the slot here because a) we can't
> +			 * (no pending session in the TPM to evict)
> +			 * and b) no-one is hogging sessions, so no
> +			 * evidence of need.
> +			 */
> +			return 0;
> +
> +		/* timed out or victim required; select a victim
> +		 * session to kill
> +		 */
> +		sess = tpm2_session_chip_find_oldest(chip);
> +		if (sess == NULL) {
> +			/* we get here when we can't create a session
> +			 * but there are no listed active sessions
> +			 * meaning they're all in various space
> +			 * structures as victim sessions.  The wait
> +			 * queue is a fair sequence, so we need to
> +			 * wait a bit harder
> +			 */
> +			if (failed++ > 3)
> +				break;
> +			timeout *= 2;
> +			dev_info(&chip->dev, "failed to get session, waiting for %us\n", jiffies_to_msecs(timeout)/1000);
> +			continue;
> +		}
> +		/* is the victim old enough? */
> +		timeout = jiffies - sess->created;
> +		if (timeout > min_timeout)
> +			break;
> +		/* otherwise wait until the victim is old enough */
> +		timeout = min_timeout - timeout;
> +	}
> +	if (sess == NULL)
> +		/* still can't get a victim, give up */
> +		return -EINVAL;
> +
> +	/* store the physical handle */
> +	space->reserved_handle = sess->handle;
> +	dev_info(&chip->dev, "Selecting handle %08x for eviction\n",
> +		 space->reserved_handle);
> +
> +	/* cause a mapping failure if this session handle is
> +	 * ever used in the victim space again
> +	 */
> +	tpm2_session_forget(chip, sess->space, sess->handle);
> +	/* clear the session, but don't wake any other waiters */
> +	memset(sess, 0, sizeof(*sess));
> +	/* so now we have a saved physical handle but this handle is
> +	 * still in the tpm.  After this we repeat the command, but
> +	 * flush the handle once we obtain the tpm_mutex on the repeat
> +	 * so, in theory, we should have a free handle to
> +	 * re-execute
> +	 */
> +
> +	return 0;
> +}
> +
>  int tpm2_init_space(struct tpm_chip *chip, struct tpm_space *space)
>  {
>  	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> @@ -65,8 +225,7 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
>  			 __func__, rc);
>  		tpm_buf_destroy(&tbuf);
>  		return -EFAULT;
> -	} else if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE ||
> -		   rc == TPM2_RC_REFERENCE_H0) {
> +	} else if (rc == TPM2_RC_REFERENCE_H0) {
>  		rc = -ENOENT;
>  		tpm_buf_destroy(&tbuf);
>  	} else if (rc > 0) {
> @@ -126,9 +285,9 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
>  	return 0;
>  }
>  
> -static int tpm2_session_add(struct tpm_chip *chip,
> -			    struct tpm_space *space, u32 handle)
> +static int tpm2_session_add(struct tpm_chip *chip, u32 handle)
>  {
> +	struct tpm_space *space = &chip->work_space;
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
> @@ -141,6 +300,7 @@ static int tpm2_session_add(struct tpm_chip *chip,
>  	}
>  
>  	space->session_tbl[i] = handle;
> +	tpm2_session_chip_add(chip, chip->space, handle);
>  
>  	return 0;
>  }
> @@ -155,9 +315,18 @@ void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
>  					       TPM_TRANSMIT_UNLOCKED);
>  
>  	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> -		if (space->session_tbl[i])
> -			tpm2_flush_context_cmd(chip, space->session_tbl[i],
> -					       TPM_TRANSMIT_UNLOCKED);
> +		if (!space->session_tbl[i])
> +			continue;
> +
> +		tpm2_session_chip_remove(chip, space->session_tbl[i]);
> +		tpm2_flush_context_cmd(chip, space->session_tbl[i],
> +				       TPM_TRANSMIT_UNLOCKED);
> +	}
> +	if (space->reserved_handle && !tpm2_is_session_force_evict(space)) {
> +		tpm2_flush_context_cmd(chip, space->reserved_handle,
> +				       TPM_TRANSMIT_UNLOCKED);
> +		space->reserved_handle = 0;
> +		/* subtlety here: if force evict is set, we don't clear it */
>  	}
>  }
>  
> @@ -194,6 +363,7 @@ static int tpm2_load_space(struct tpm_chip *chip)
>  				       &offset, &handle);
>  		if (rc == -ENOENT) {
>  			/* load failed, just forget session */
> +			tpm2_session_chip_remove(chip, space->session_tbl[i]);
>  			space->session_tbl[i] = 0;
>  		} else if (rc) {
>  			tpm2_flush_space(chip, space);
> @@ -269,6 +439,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
>  	       sizeof(space->session_tbl));
>  	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
>  	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
> +	chip->space = space;
>  
>  	rc = tpm2_load_space(chip);
>  	if (rc) {
> @@ -282,16 +453,28 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
>  		return rc;
>  	}
>  
> +	if (space->reserved_handle && !tpm2_is_session_force_evict(space)) {
> +		/* this is a trick to allow a previous command which
> +		 * failed because it was out of handle space to
> +		 * succeed.  The handle is still in the TPM, so now we
> +		 * flush it under the tpm_mutex which should ensure we
> +		 * can create a new one
> +		 */
> +		tpm2_flush_context_cmd(chip, space->reserved_handle,
> +				       TPM_TRANSMIT_UNLOCKED);
> +		space->reserved_handle = 0;
> +	}
> +
>  	return 0;
>  }
>  
> -static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
> +static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len,
> +			     u32 return_code)
>  {
>  	struct tpm_space *space = &chip->work_space;
>  	u32 phandle, phandle_type;
>  	u32 vhandle;
>  	u32 attrs;
> -	u32 return_code = get_unaligned_be32((__be32 *)&rsp[6]);
>  	int i;
>  
>  	if (return_code != TPM2_RC_SUCCESS)
> @@ -314,7 +497,7 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
>  		return 0;
>  
>  	if (phandle_type != TPM2_HT_TRANSIENT)
> -		return tpm2_session_add(chip, space, phandle);
> +		return tpm2_session_add(chip, phandle);
>  
>  	/* Garbage collect a dead context. */
>  	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
> @@ -376,6 +559,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
>  
>  		if (rc == -ENOENT) {
>  			/* handle error saving session, just forget it */
> +			tpm2_session_chip_remove(chip, space->session_tbl[i]);
>  			space->session_tbl[i] = 0;
>  		} else if (rc < 0) {
>  			tpm2_flush_space(chip, space);
> @@ -390,11 +574,12 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  		      u32 cc, u8 *buf, size_t bufsiz)
>  {
>  	int rc;
> +	u32 return_code = get_unaligned_be32((__be32 *)&buf[6]);
>  
>  	if (!space)
>  		return 0;
>  
> -	rc = tpm2_map_response(chip, cc, buf, bufsiz);
> +	rc = tpm2_map_response(chip, cc, buf, bufsiz, return_code);
>  	if (rc) {
>  		tpm2_flush_space(chip, space);
>  		return rc;
> @@ -412,6 +597,12 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  	       sizeof(space->session_tbl));
>  	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
>  	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
> +	chip->space = NULL;
> +
> +	if (return_code == TPM2_RC_SESSION_HANDLES) {
> +		tpm2_session_wait(chip, space);
> +		return -EAGAIN;
> +	}
>  
>  	return 0;
>  }
> diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
> index 6efead3..9766fb4 100644
> --- a/drivers/char/tpm/tpms-dev.c
> +++ b/drivers/char/tpm/tpms-dev.c
> @@ -58,8 +58,23 @@ ssize_t tpms_write(struct file *file, const char __user *buf,
>  {
>  	struct file_priv *fpriv = file->private_data;
>  	struct tpms_priv *priv = container_of(fpriv, struct tpms_priv, priv);
> +	int count = 0;
> +	const int max_count = 3; /* number of retries */
> +	int rc;
> +
> +	for (count = 0; count < max_count; count++) {
> +		rc = tpm_common_write(file, buf, size, off, &priv->space);
> +		if (rc != -EAGAIN)
> +			break;
> +		if (count == max_count - 2)
> +			/* second to last go around, force an eviction if
> +			 * this go fails, so final go should succeed
> +			 */
> +			tpm2_session_force_evict(&priv->space);
> +	}
> +	tpm2_session_clear_reserved(fpriv->chip, &priv->space);
>  
> -	return tpm_common_write(file, buf, size, off, &priv->space);
> +	return rc;
>  }
>  
>  const struct file_operations tpms_fops = {
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
