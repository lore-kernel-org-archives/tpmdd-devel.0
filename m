From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Fri, 27 Jan 2017 17:06:18 -0500
Message-ID: <o6gg8g$4j6$2@blaine.gmane.org>
References: <1485236113.2534.69.camel@HansenPartnership.com>
	<1485236231.2534.71.camel@HansenPartnership.com>
	<20170126125151.32sky3tajp6zigpd@intel.com>
	<1485443929.2457.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485443929.2457.5.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/26/2017 10:18 AM, James Bottomley wrote:
>>
>> I'm wondering if you ever need more than two sessions at once? If we
>> would limit the number of sessions to that you could probably
>> simplify a lot.
>
> Three seems to be the agreed maximum: hmac authority, parameter
> encryption and command audit.

3 is recommended.

There is also the possibility that the encrypt (response) and decrypt 
(command) parameters could use different keys, and thus need their own 
session.

FYI: It is possible to have one session that does HMAC, parameter
encryption for command and response, and audit.





------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
