From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm: add sleep only for retry in
 i2c_nuvoton_write_status()
Date: Mon, 13 Mar 2017 20:26:04 +0200
Message-ID: <20170313182604.yhfhbqve2wufa2f4@intel.com>
References: <1489171554-6844-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1489171554-6844-2-git-send-email-nayna@linux.vnet.ibm.com>
 <1489416862.28954.156.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489416862.28954.156.camel@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, "linux-4.8" <stable@vger.kernel.org>, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 10:54:22AM -0400, Mimi Zohar wrote:
> Hi Jarkko,
> 
> On Fri, 2017-03-10 at 13:45 -0500, Nayna Jain wrote:
> > Currently, there is an unnecessary 1 msec delay added in
> > i2c_nuvoton_write_status() for the successful case. This 
> > function is called multiple times during send() and recv(),
> > which implies adding multiple extra delays for every TPM
> > operation.
> > 
> > This patch calls usleep_range() only if retry is to be done.
> > 
> > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > Cc: stable@vger.kernel.org (linux-4.8)
> > Reviewed-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> 
> Either Reviewed-by/Acked-by is fine. 
> 
> Can you pick up this patch and replace the original version of "tpm:
> msleep() delays - replace with usleep_range()" with the one Nayna
> posted?
> 
> Thanks!
> 
> Mimi

Yes, sure. I'll try to get that done as soon as possible..

/Jarkko

> 
> > ---
> >  drivers/char/tpm/tpm_i2c_nuvoton.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > index 0c98c42..c642877 100644
> > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > @@ -124,8 +124,9 @@ static s32 i2c_nuvoton_write_status(struct i2c_client *client, u8 data)
> >  	/* this causes the current command to be aborted */
> >  	for (i = 0, status = -1; i < TPM_I2C_RETRY_COUNT && status < 0; i++) {
> >  		status = i2c_nuvoton_write_buf(client, TPM_STS, 1, &data);
> > -		usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> > -			     + TPM_I2C_DELAY_RANGE);
> > +		if (status < 0)
> > +			usleep_range(TPM_I2C_BUS_DELAY, TPM_I2C_BUS_DELAY
> > +				     + TPM_I2C_DELAY_RANGE);
> >  	}
> >  	return status;
> >  }
> 
> 
