From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Wed, 25 Oct 2017 21:34:52 +0200
Message-ID: <20171025193452.d4qa4dhacfgqejk7@linux.intel.com>
References: <20171025115508.5682-1-jarkko.sakkinen@linux.intel.com>
 <CANc+2y46q85+G1=9cXKW0R8FpGBqCuzkLnJzvSYFQ1S=ztKGew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y46q85+G1=9cXKW0R8FpGBqCuzkLnJzvSYFQ1S=ztKGew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, David Safford <safford@us.ibm.com>, David Howells <dhowells@redhat.com>, Jerry Snitselaar <jsnitsel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 25, 2017 at 08:40:26PM +0530, PrasannaKumar Muralidharan wrote:
> > -struct tpm_chip *tpm_chip_find_get(int chip_num)
> > +struct tpm_chip *tpm_chip_find_get(struct tpm_chip *chip)
> >  {
> > -       struct tpm_chip *chip, *res = NULL;
> > +       struct tpm_chip *res = NULL;
> > +       int chip_num = 0;
> >         int chip_prev;
> >
> >         mutex_lock(&idr_lock);
> >
> > -       if (chip_num == TPM_ANY_NUM) {
> > -               chip_num = 0;
> > +       if (!chip) {
> >                 do {
> >                         chip_prev = chip_num;
> >                         chip = idr_get_next(&dev_nums_idr, &chip_num);
> 
> When chip is not NULL just do tpm_try_get_ops(chip). Current code does
> more things which are not required.

Your observation is right that there is something wrong but conclusions
are incorrect.

It's actually a regression.

If @chip has a value, the code does one iteration of what it is doing in
the first branch of the condition. That is completely bogus semantics to
say the least.

To sort that out I'll introduce a new field to struct tpm_chip:

  u64 id;

This gets a value from a global count every time a chip is created.

The function will become then:

struct tpm_chip *tpm_chip_find_get(u64 id)
{
	struct tpm_chup *chip;
	struct tpm_chip *res = NULL;
	int chip_num = 0;
	int chip_prev;

	mutex_lock(&idr_lock);

	do {
		chip_prev = chip_num;

		chip = idr_get_next(&dev_nums_idr, &chip_num);

		if (chip && (!id || id == chip->id) && !tpm_try_get_ops(chip)) {
			res = chip;
			break;
		}
	} while (chip_prev != chip_num);

	mutex_unlock(&idr_lock);

	return res;
}

Thanks for spotting this out. I'll refine the patch.

/Jarkko
