From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3] tpm: use struct tpm_chip for tpm_chip_find_get()
Date: Thu, 26 Oct 2017 10:50:27 -0600
Message-ID: <20171026165027.GA5829@obsidianresearch.com>
References: <20171026135453.24672-1-jarkko.sakkinen@linux.intel.com>
 <CANc+2y7D+p+wq1tKCydZU0qwWWfUscv3+CQuxPNfzEacEzVDBg@mail.gmail.com>
 <20171026160759.bycrmywqqxtjzpqk@linux.intel.com>
 <CANc+2y7hknynCpgmRk2uYH7k5QFdH3hER0jNayNfZUymOEyr6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y7hknynCpgmRk2uYH7k5QFdH3hER0jNayNfZUymOEyr6A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, David Safford <safford@us.ibm.com>, David Howells <dhowells@redhat.com>, Jerry Snitselaar <jsnitsel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)" <linux-ima-devel@lists.sour>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 26, 2017 at 09:57:12PM +0530, PrasannaKumar Muralidharan
wrote:

> I do not what value my rb tag provides as I have not contributed code
> to it before. Is it encouraged by kernel community?

Yes. People will judge the quality of your rb tag based on other
reviews they have seen you make, and here you found a bug, so very
good.

Got to start someplace.

Jason
