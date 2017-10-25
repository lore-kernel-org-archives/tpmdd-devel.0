From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Wed, 25 Oct 2017 22:07:46 +0200
Message-ID: <20171025200746.svsraubdotjyzt2i@linux.intel.com>
References: <20171025115508.5682-1-jarkko.sakkinen@linux.intel.com>
 <CANc+2y46q85+G1=9cXKW0R8FpGBqCuzkLnJzvSYFQ1S=ztKGew@mail.gmail.com>
 <20171025193452.d4qa4dhacfgqejk7@linux.intel.com>
 <20171025194633.GB998@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171025194633.GB998@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, David Safford <safford@us.ibm.com>, David Howells <dhowells@redhat.com>, Jerry Snitselaar <jsnitsel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 25, 2017 at 01:46:33PM -0600, Jason Gunthorpe wrote:
> > struct tpm_chip *tpm_chip_find_get(u64 id)
> > {
> > 	struct tpm_chup *chip;
> > 	struct tpm_chip *res = NULL;
> > 	int chip_num = 0;
> > 	int chip_prev;
> > 
> > 	mutex_lock(&idr_lock);
> > 
> > 	do {
> > 		chip_prev = chip_num;
> > 
> > 		chip = idr_get_next(&dev_nums_idr, &chip_num);
> > 
> > 		if (chip && (!id || id == chip->id) && !tpm_try_get_ops(chip)) {
> > 			res = chip;
> > 			break;
> > 		}
> > 	} while (chip_prev != chip_num);
> > 
> > 	mutex_unlock(&idr_lock);
> > 
> > 	return res;
> > }
> 
> ?? The old version was correct, idr_find_slowpath is better than an
> idr_get_next serach if you already know id.
> 
> PrasannaKumar's solution seems right, if we already have chip, then we
> just need to lock it again:
> 
> struct tpm_chip *tpm_chip_find_get(struct tpm_chip *chip)
> {
> 	struct tpm_chip *res = NULL;
> 
> 	mutex_lock(&idr_lock);
> 
> 	if (!chip) {
> 		int chip_num = 0;
> 		int chip_prev;
> 
> 		do {
> 			chip_prev = chip_num;
> 			chip = idr_get_next(&dev_nums_idr, &chip_num);
> 			if (chip && !tpm_try_get_ops(chip)) {
> 				res = chip;
> 				break;
> 			}
> 		} while (chip_prev != chip_num);
> 	} else {
> 		if (!tpm_try_get_ops(chip))
> 			res = chip;
> 	}
> 
> 	mutex_unlock(&idr_lock);
> 
> 	return res;
> }
> 
> Jason

The id has a nice feature that it is unique for one boot cycle you can
even try to get a chip that has been deleted. It has the most stable
properties in the long run.

Address is a reusable identifier in one boot cycle.

/Jarkko
