From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH 1/2] tpm: add sysfs attributes for tpm2
Date: Fri, 15 Jul 2016 09:56:58 -0700
Message-ID: <20160715165658.GA109276@apronin>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
 <1468547496-16215-2-git-send-email-apronin@chromium.org>
 <20160715032145.GE9347@obsidianresearch.com>
 <20160715033201.GA27104@apronin>
 <20160715033439.GI9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160715033439.GI9347@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 09:34:39PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 08:32:01PM -0700, Andrey Pronin wrote:
> 
> > tpm2 shares some of the attributes with tpm1 (e.g. timeouts). Do I still
> > just add those separately for tpm2 to groups[1] and keep groups[0] empty?

Just realized that if we keep tpm_add_legacy_sysfs() intact, it doesn't
create symlinks for tpm2 case for any of the groups, including groups[0].
So, in tpm_sysfs_add_device() can just do smth like:

if (chip->flags & TPM_CHIP_FLAG_TPM2)
	chip->groups[chip->groups_cnt++] = &tpm2_dev_group;
else
	chip->groups[chip->groups_cnt++] = &tpm_dev_group;

Is that acceptable? Will submit the next version along those lines.

> 
> I think so. Since the file never exists for tpm2, nothing coded for
> tpm2 will ever look in the old location.
> 

There can be a common code working with tpm1.2 that will just continue
working with tpm2 if the common attributes are in the same place. So, some
part of code can be re-used as is, but I agree that there are not too
many common attributes. Will drop for now. Can be addressed later if
the clear need arises.
